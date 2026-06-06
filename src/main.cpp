#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>

#include "enginecontroller.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    FileIo fileIo;
    EngineController engineController;
    engine.rootContext()->setContextProperty(QStringLiteral("fileIo"), &fileIo);
    engine.rootContext()->setContextProperty(QStringLiteral("engineController"), &engineController);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Lizzie3D", "Main");

    return app.exec();
}
