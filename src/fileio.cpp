#include "fileio.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>

FileIo::FileIo(QObject *parent)
    : QObject(parent)
{
}

QString FileIo::lastError() const
{
    return m_lastError;
}

bool FileIo::writeTextFile(const QUrl &url, const QString &text)
{
    const QString path = url.isLocalFile() ? url.toLocalFile() : url.toString(QUrl::PreferLocalFile);
    if (path.isEmpty()) {
        setLastError(QStringLiteral("Empty file path."));
        return false;
    }

    const QFileInfo info(path);
    const QDir dir = info.absoluteDir();
    if (!dir.exists() && !QDir().mkpath(dir.absolutePath())) {
        setLastError(QStringLiteral("Cannot create directory: %1").arg(dir.absolutePath()));
        return false;
    }

    QFile file(path);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        setLastError(file.errorString());
        return false;
    }

    const QByteArray bytes = text.toUtf8();
    if (file.write(bytes) != bytes.size()) {
        setLastError(file.errorString());
        return false;
    }

    setLastError(QString());
    return true;
}

void FileIo::setLastError(const QString &message)
{
    if (m_lastError == message)
        return;

    m_lastError = message;
    emit lastErrorChanged();
}
