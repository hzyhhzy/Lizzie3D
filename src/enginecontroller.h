#pragma once

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QVariantList>

class EngineController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString command READ command WRITE setCommand NOTIFY commandChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)
    Q_PROPERTY(QVariantList candidates READ candidates NOTIFY candidatesChanged)
    Q_PROPERTY(int candidateRevision READ candidateRevision NOTIFY candidatesChanged)

public:
    explicit EngineController(QObject *parent = nullptr);
    ~EngineController() override;

    QString command() const;
    void setCommand(const QString &command);

    bool running() const;
    QString statusText() const;
    QString lastError() const;
    QVariantList candidates() const;
    int candidateRevision() const;

    Q_INVOKABLE void ensureStarted();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void sendCommand(const QString &command);
    Q_INVOKABLE void requestAnalysis(const QStringList &syncCommands, const QString &analyzeCommand);
    Q_INVOKABLE void clearCandidates();

signals:
    void commandChanged();
    void runningChanged();
    void statusTextChanged();
    void lastErrorChanged();
    void candidatesChanged();
    void engineOutput(const QString &line);
    void engineErrorOutput(const QString &line);

private:
    static QStringList splitCommandLine(const QString &commandLine);
    void startProcess();
    void sendPendingCommands();
    void readStandardOutput();
    void readStandardError();
    void consumeLines(QByteArray &buffer, bool stderrStream);
    void handleStdoutLine(const QString &line);
    void handleStderrLine(const QString &line);
    void parseInfoLine(const QString &line);
    void setRunning(bool running);
    void setStatusText(const QString &text);
    void setLastError(const QString &text);

    QProcess m_process;
    QString m_command;
    bool m_running = false;
    QString m_statusText;
    QString m_lastError;
    QVariantList m_candidates;
    int m_candidateRevision = 0;
    QStringList m_pendingCommands;
    QByteArray m_stdoutBuffer;
    QByteArray m_stderrBuffer;
};
