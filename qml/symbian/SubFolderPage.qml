/**
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "SymbianUIConstants.js" as Constants

Page {

    property string folder

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"

            onClicked: {
                pageStack.pop();
            }
        }
    }

    Image{
        anchors.fill: parent
        source: "qrc:/background.svg"
    }

    ScrollDecorator {
        flickableItem: list.modelView
    }

    // Main flickable component
    Flickable{
        id: flick

        clip: true

        anchors {
            top: parent.top;
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentHeight: col.implicitHeight

        // Phone mmory folder list
        Column{
            id: col
            width: parent.width

            FolderList {
                id: list

                width: parent.width

                contentOpacity: 0

                onFolderSelected: {
                    pageStack.push(Qt.resolvedUrl("SubFolderPage.qml"), { folder: folder });
                }


                onFileSelected: {
                    // Try to open the selected file
                    if (!fileHelper.openUrl(file)) {
                        console.debug("FileListPage.qml: " +
                                      "phoneMemoryFolderList::onFileSelected: Failed to open",
                                      file);
                    }
                }

                Behavior on contentOpacity {
                    NumberAnimation{
                        duration: Constants.DEFAULT_ANIM_DURATION
                    }
                }
            }
        }
    }

    // Informational text in case the current folder contains no files
    Text {
        id: noFilesText
        anchors.centerIn: parent
        opacity: 0
        color: "#555555"
        font.pixelSize: 50
        text: "No files"

        Behavior on opacity {
            NumberAnimation { duration: Constants.DEFAULT_ANIM_DURATION }
        }
    }

    Timer {
        id: timer

        interval: Constants.SWITCH_PAGE_ANIM_DURATION

        onTriggered: {
            list.contentOpacity = 1;

            if (list.count == 0) {
                noFilesText.opacity = 1;
            }

            timer.stop();
        }
    }

    Connections{
        target: pageStack
        onBusyChanged: {
            // Check if page switch animation completed, if so set folder
            if(pageStack.busy === false)
            {
                console.log("Page transition finished");
                list.folder = folder;

                timer.start();
            }
        }
    }
}

// End of file.
