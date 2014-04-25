/**
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

PageStackWindow {
    id: root

    showStatusBar: true
    showToolBar: true
    initialPage: FileListPage {}

    // Title text on status bar
    Text {
        anchors {
            //top: statusBar.top
            left: parent.left
            leftMargin: platformStyle.paddingSmall
        }

        z: 2

        font {
            family: platformStyle.fontFamilyRegular
            pixelSize: platformStyle.fontSizeMedium
        }

        color: platformStyle.colorNormalLight
        text: "FileList"
    }


}

// End of file.
