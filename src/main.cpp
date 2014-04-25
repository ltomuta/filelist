/**
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

// Qt includes
#include <QtGui/QApplication>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QDeclarativeEngine>

// filelist includes
#include "filehelper.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QDeclarativeView view;
    view.setAttribute(Qt::WA_NoSystemBackground);
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);

    // Construct FileHelper instance and expose it to QML.
    FileHelper fileHelper;
    view.engine()->rootContext()->setContextProperty("fileHelper", &fileHelper);

    // Display the QML content
    view.setSource(QUrl::fromLocalFile("qml/symbian/MainAppLoader.qml"));
    view.showFullScreen();

    return app.exec();
}

// End of file.
