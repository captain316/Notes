#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFileSelector>
#include <QFile>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
   // QQuickStyle::setStyle("Fusion");
    QQmlApplicationEngine engine;

    QFileSelector selector;
    QFile defaultsFile(selector.select("chapter4-3shared/main.qml"));
  //  QFile defaultsconfig(selector.select("chapter4-3shared/default.cof"));
  //  qDebug()<<defaultsFile.fileName();

    if(defaultsFile.fileName().contains("+android"))
        QQuickStyle::setStyle("Material");
    else
        QQuickStyle::setStyle("Fusion");

    const QUrl url(defaultsFile.fileName());
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
