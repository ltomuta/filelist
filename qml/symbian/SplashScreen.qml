/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import "SymbianUIConstants.js" as Constants

Item {
    id: splashScreen

    property alias progressBarValue: progressBar.currentValue

    Image {
        anchors.fill: parent
        source: "qrc:/background.svg"
    }

    Column {
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: Constants.DEFAULT_MARGIN * 2

        Text {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.pixelSize: Constants.SPLASHSCREEN_FONT_POINTSIZE
            text: "FileList"
        }

        CustomProgressBar {
            id: progressBar
            width: splashScreen.width * 0.75
            anchors.horizontalCenter: parent.horizontalCenter
            maxValue: Constants.PROGRESSBAR_MAX_VALUE
        }
    }

    Behavior on opacity { NumberAnimation { duration: 500 } }
}

// End of file.
