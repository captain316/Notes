#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "cppmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/chapter17-3modelview/main.qml"_qs);
    qmlRegisterType<CppModel>("org.example",1,0,"CppModel");
    engine.load(url);

    return app.exec();
}
