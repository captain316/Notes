#include "mainwindow.h"
#include <QtWidgets>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    QPushButton* button=new QPushButton("Store Content",this);
    setCentralWidget(button);
    connect(button,&QPushButton::clicked,this,&MainWindow::storeContent);
}

MainWindow::~MainWindow()
{
}

void MainWindow::storeContent()
{
    QString message("Hello World!!!!!!!!");

    QFile file(QDir::home().absoluteFilePath("out.txt"));

    if(!file.open(QIODevice::WriteOnly)){
        qWarning()<<"Cannot open file";
        return;
    }

    QTextStream stream(&file);

    stream<<message;
}

