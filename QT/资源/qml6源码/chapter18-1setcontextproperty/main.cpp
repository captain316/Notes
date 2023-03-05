#include <QtGui>
#include <QtQml>
#include <QTime>
class CurrentTime{
public:
    QString value(){return QTime::currentTime().toString();}
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    CurrentTime current;
    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/chapter18-1setcontextproperty/main.qml"_qs);
    engine.rootContext()->setContextProperty("current",current.value());
    engine.load(url);
    Sleep(2000);
    engine.rootContext()->setContextProperty("current",current.value());
    return app.exec();
}
