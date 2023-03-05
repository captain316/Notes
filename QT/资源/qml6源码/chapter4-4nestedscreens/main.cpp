#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("chapter4-4nestedscreens/images/le.ico"));
    QQuickStyle::setStyle("Material");
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/chapter4-4nestedscreens/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
