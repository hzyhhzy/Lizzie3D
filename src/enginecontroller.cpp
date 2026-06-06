#include "enginecontroller.h"

#include <QCoreApplication>
#include <QRegularExpression>
#include <QVariantMap>

#include <algorithm>

namespace {
constexpr auto kDefaultEngineCommand =
    "C:\\katago\\engine_cuda129\\go3d_7x.exe gtp -config C:/Lizzie/engine2024.cfg "
    "-model D:\\kata2026\\go3d_7x\\data\\latest.onnx -override-config useGraphSearch=false";

double normalizedWinrate(double value)
{
    if (value <= 1.0)
        return value * 100.0;
    if (value > 100.0)
        return value / 100.0;
    return value;
}
}

EngineController::EngineController(QObject *parent)
    : QObject(parent)
    , m_command(QString::fromUtf8(kDefaultEngineCommand))
    , m_statusText(QStringLiteral("Engine not started"))
{
    m_process.setProcessChannelMode(QProcess::SeparateChannels);

    connect(&m_process, &QProcess::started, this, [this]() {
        setRunning(true);
        setStatusText(QStringLiteral("Engine started"));
        sendPendingCommands();
    });

    connect(&m_process, &QProcess::readyReadStandardOutput, this, &EngineController::readStandardOutput);
    connect(&m_process, &QProcess::readyReadStandardError, this, &EngineController::readStandardError);

    connect(&m_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
        QString message;
        switch (error) {
        case QProcess::FailedToStart:
            message = QStringLiteral("Failed to start engine");
            break;
        case QProcess::Crashed:
            message = QStringLiteral("Engine crashed");
            break;
        case QProcess::Timedout:
            message = QStringLiteral("Engine timed out");
            break;
        case QProcess::WriteError:
            message = QStringLiteral("Engine write error");
            break;
        case QProcess::ReadError:
            message = QStringLiteral("Engine read error");
            break;
        case QProcess::UnknownError:
            message = QStringLiteral("Unknown engine error");
            break;
        }
        if (!m_process.errorString().isEmpty())
            message += QStringLiteral(": ") + m_process.errorString();
        setLastError(message);
        setStatusText(message);
    });

    connect(&m_process,
            qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this,
            [this](int exitCode, QProcess::ExitStatus exitStatus) {
                setRunning(false);
                QString message = exitStatus == QProcess::CrashExit
                                      ? QStringLiteral("Engine crashed")
                                      : QStringLiteral("Engine exited");
                message += QStringLiteral(" (%1)").arg(exitCode);
                setStatusText(message);
            });
}

EngineController::~EngineController()
{
    stop();
}

QString EngineController::command() const
{
    return m_command;
}

void EngineController::setCommand(const QString &command)
{
    if (m_command == command)
        return;
    m_command = command;
    emit commandChanged();
}

bool EngineController::running() const
{
    return m_running;
}

QString EngineController::statusText() const
{
    return m_statusText;
}

QString EngineController::lastError() const
{
    return m_lastError;
}

QVariantList EngineController::candidates() const
{
    return m_candidates;
}

int EngineController::candidateRevision() const
{
    return m_candidateRevision;
}

void EngineController::ensureStarted()
{
    if (m_process.state() != QProcess::NotRunning)
        return;
    startProcess();
}

void EngineController::restart()
{
    if (m_process.state() != QProcess::NotRunning) {
        m_process.kill();
        m_process.waitForFinished(1200);
    }
    setRunning(false);
    startProcess();
}

void EngineController::stop()
{
    if (m_process.state() == QProcess::NotRunning)
        return;

    sendCommand(QStringLiteral("quit"));
    m_process.closeWriteChannel();
    if (!m_process.waitForFinished(1000))
        m_process.kill();
}

void EngineController::sendCommand(const QString &command)
{
    if (command.trimmed().isEmpty())
        return;

    if (m_process.state() == QProcess::NotRunning) {
        m_pendingCommands.append(command);
        startProcess();
        return;
    }

    if (m_process.state() == QProcess::Starting) {
        m_pendingCommands.append(command);
        return;
    }

    const QByteArray bytes = command.toUtf8() + '\n';
    m_process.write(bytes);
}

void EngineController::requestAnalysis(const QStringList &syncCommands, const QString &analyzeCommand)
{
    clearCandidates();
    m_pendingCommands = syncCommands;
    if (!analyzeCommand.trimmed().isEmpty())
        m_pendingCommands.append(analyzeCommand.trimmed());

    if (m_process.state() == QProcess::Running) {
        sendPendingCommands();
    } else if (m_process.state() == QProcess::NotRunning) {
        startProcess();
    } else {
        setStatusText(QStringLiteral("Starting engine"));
    }
}

void EngineController::clearCandidates()
{
    if (m_candidates.isEmpty())
        return;

    m_candidates.clear();
    ++m_candidateRevision;
    emit candidatesChanged();
}

QStringList EngineController::splitCommandLine(const QString &commandLine)
{
    QStringList result;
    QString current;
    bool inSingleQuote = false;
    bool inDoubleQuote = false;
    bool justClosedQuote = false;

    for (const QChar ch : commandLine) {
        if (ch == QLatin1Char('\'') && !inDoubleQuote) {
            inSingleQuote = !inSingleQuote;
            justClosedQuote = !inSingleQuote;
            continue;
        }
        if (ch == QLatin1Char('"') && !inSingleQuote) {
            inDoubleQuote = !inDoubleQuote;
            justClosedQuote = !inDoubleQuote;
            continue;
        }
        if (ch.isSpace() && !inSingleQuote && !inDoubleQuote) {
            if (!current.isEmpty() || justClosedQuote) {
                result.append(current);
                current.clear();
                justClosedQuote = false;
            }
            continue;
        }

        current.append(ch);
        justClosedQuote = false;
    }

    if (!current.isEmpty() || justClosedQuote)
        result.append(current);
    return result;
}

void EngineController::startProcess()
{
    const QStringList parts = splitCommandLine(m_command);
    if (parts.isEmpty()) {
        setLastError(QStringLiteral("Engine command is empty"));
        setStatusText(m_lastError);
        return;
    }

    setLastError(QString());
    setStatusText(QStringLiteral("Starting engine"));
    m_stdoutBuffer.clear();
    m_stderrBuffer.clear();
    m_process.setWorkingDirectory(QCoreApplication::applicationDirPath());
    m_process.start(parts.first(), parts.mid(1));
}

void EngineController::sendPendingCommands()
{
    if (m_process.state() != QProcess::Running)
        return;

    const QStringList commands = m_pendingCommands;
    m_pendingCommands.clear();
    for (const QString &command : commands)
        sendCommand(command);
}

void EngineController::readStandardOutput()
{
    m_stdoutBuffer.append(m_process.readAllStandardOutput());
    consumeLines(m_stdoutBuffer, false);
}

void EngineController::readStandardError()
{
    m_stderrBuffer.append(m_process.readAllStandardError());
    consumeLines(m_stderrBuffer, true);
}

void EngineController::consumeLines(QByteArray &buffer, bool stderrStream)
{
    qsizetype newlineIndex = -1;
    while ((newlineIndex = buffer.indexOf('\n')) >= 0) {
        QByteArray rawLine = buffer.left(newlineIndex);
        buffer.remove(0, newlineIndex + 1);
        if (rawLine.endsWith('\r'))
            rawLine.chop(1);
        const QString line = QString::fromUtf8(rawLine).trimmed();
        if (line.isEmpty())
            continue;
        if (stderrStream)
            handleStderrLine(line);
        else
            handleStdoutLine(line);
    }
}

void EngineController::handleStdoutLine(const QString &line)
{
    emit engineOutput(line);
    setStatusText(line);
    if (line.startsWith(QStringLiteral("info ")))
        parseInfoLine(line);
}

void EngineController::handleStderrLine(const QString &line)
{
    emit engineErrorOutput(line);
    setStatusText(line);
}

void EngineController::parseInfoLine(const QString &line)
{
    QString payload = line;
    if (payload.startsWith(QStringLiteral("info ")))
        payload = payload.mid(5);

    const QStringList segments =
        payload.split(QRegularExpression(QStringLiteral("\\s+info\\s+")), Qt::SkipEmptyParts);
    QVariantList parsedCandidates;
    int segmentIndex = 0;

    for (const QString &segment : segments) {
        const QStringList tokens =
            segment.trimmed().split(QRegularExpression(QStringLiteral("\\s+")), Qt::SkipEmptyParts);
        if (tokens.isEmpty())
            continue;

        QVariantMap item;
        item.insert(QStringLiteral("order"), segmentIndex);
        item.insert(QStringLiteral("raw"), segment.trimmed());

        for (int i = 0; i + 1 < tokens.size(); ++i) {
            const QString key = tokens.at(i);
            const QString value = tokens.at(i + 1);
            bool ok = false;

            if (key == QStringLiteral("move")) {
                item.insert(QStringLiteral("move"), value);
                ++i;
            } else if (key == QStringLiteral("order")) {
                const int order = value.toInt(&ok);
                if (ok)
                    item.insert(QStringLiteral("order"), order);
                ++i;
            } else if (key == QStringLiteral("visits")) {
                const int visits = value.toInt(&ok);
                if (ok)
                    item.insert(QStringLiteral("visits"), visits);
                ++i;
            } else if (key == QStringLiteral("winrate")) {
                const double winrate = value.toDouble(&ok);
                if (ok)
                    item.insert(QStringLiteral("winrate"), normalizedWinrate(winrate));
                ++i;
            } else if (key == QStringLiteral("scoreMean")) {
                const double scoreMean = value.toDouble(&ok);
                if (ok)
                    item.insert(QStringLiteral("scoreMean"), scoreMean);
                ++i;
            } else if (key == QStringLiteral("scoreStdev")) {
                const double scoreStdev = value.toDouble(&ok);
                if (ok)
                    item.insert(QStringLiteral("scoreStdev"), scoreStdev);
                ++i;
            } else if (key == QStringLiteral("pv")) {
                break;
            }
        }

        if (item.contains(QStringLiteral("move")))
            parsedCandidates.append(item);
        ++segmentIndex;
    }

    if (parsedCandidates.isEmpty())
        return;

    std::sort(parsedCandidates.begin(), parsedCandidates.end(), [](const QVariant &a, const QVariant &b) {
        const QVariantMap left = a.toMap();
        const QVariantMap right = b.toMap();
        return left.value(QStringLiteral("order")).toInt() < right.value(QStringLiteral("order")).toInt();
    });

    m_candidates = parsedCandidates;
    ++m_candidateRevision;
    emit candidatesChanged();
}

void EngineController::setRunning(bool running)
{
    if (m_running == running)
        return;
    m_running = running;
    emit runningChanged();
}

void EngineController::setStatusText(const QString &text)
{
    if (m_statusText == text)
        return;
    m_statusText = text;
    emit statusTextChanged();
}

void EngineController::setLastError(const QString &text)
{
    if (m_lastError == text)
        return;
    m_lastError = text;
    emit lastErrorChanged();
}
