#include <QString>
#include <QFile>
#include <QDir>
#include <QTextStream>

int main(int argc, char *argv[])
{
    QString message("Hello World!!!");

    QFile file(QDir::home().absoluteFilePath("out.txt"));

    if(!file.open(QIODevice::WriteOnly)){
        qWarning()<<"Cannot open file";
        return -1;
    }

    QTextStream stream(&file);

    stream<<message;

    return 0;
}
