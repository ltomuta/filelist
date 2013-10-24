/**
 * Copyright (c) 2011-2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "SymbianUIConstants.js" as Constants

Page {
    id: fileListPage

    // For keeping track of the currently browsed content type
    property int contentType: Constants.ContentType.Images;

    // Flag indicating if memory card is detected
    property bool memoryCardPresent: false

    // Folder that the phone memory folder list is about to switch to
    property string phoneMemoryFolderToGo
    // Folder that the memory card folder list is about to switch to
    property string memoryCardFolderToGo

    property bool initialized: false;

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"

            onClicked: {
                    // Exit the application
                    Qt.quit();
            }
        }

        ButtonRow {
            id: buttonsRow
            TabButton {
                id: imagesButton
                checked: (contentType == Constants.ContentType.Images)
                iconSource: "qrc:/images-icon.png"

                onClicked: {
                    var path = fileHelper.phoneMemoryImagesPath;
                    phoneMemoryFolderList.goToFolder(fileHelper.pathUrl(path));

                    path = fileHelper.memoryCardImagesPath;
                    memoryCardFolderList.goToFolder(fileHelper.pathUrl(path));

                    contentType = Constants.ContentType.Images;
                }
            }
            TabButton {
                id: soundsButton
                checked: (contentType == Constants.ContentType.Sounds)
                iconSource: "qrc:/sounds-icon.png"

                onClicked: {
                    var path = fileHelper.phoneMemorySoundsPath;
                    phoneMemoryFolderList.goToFolder(fileHelper.pathUrl(path));

                    path = fileHelper.memoryCardSoundsPath;
                    memoryCardFolderList.goToFolder(fileHelper.pathUrl(path));

                    contentType = Constants.ContentType.Sounds;
                }
            }
            TabButton {
                id: videosButton
                checked: (contentType == Constants.ContentType.Videos)
                iconSource: "qrc:/videos-icon.png"

                onClicked: {
                    var path = fileHelper.phoneMemoryVideosPath;
                    phoneMemoryFolderList.goToFolder(fileHelper.pathUrl(path));

                    path = fileHelper.memoryCardVideosPath;
                    memoryCardFolderList.goToFolder(fileHelper.pathUrl(path));

                    contentType = Constants.ContentType.Videos;
                }
            }
        }
    }

    Image{
        anchors.fill: parent
        source: "qrc:/background.svg"
    }

    ScrollDecorator {
        flickableItem: flick
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

        Column{
            id: col
            width: parent.width

            // Phone mmory folder list
            FolderList {
                id: phoneMemoryFolderList
                width: parent.width
                visible: false

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

                function goToFolder(folder)
                {
                    phoneMemoryFolderToGo = folder;
                    flickableAnimation.restart();
                }
            }

            // Memory card folder list
            FolderList {
                id: memoryCardFolderList
                width: parent.width
                visible: false

                onFolderSelected: {
                    pageStack.push(Qt.resolvedUrl("SubFolderPage.qml"), { folder: folder });
                }

                onFileSelected: {
                    // Try to open the selected file
                    if (!fileHelper.openUrl(file)) {
                        console.debug("FileListPage.qml: " +
                                      "folderList::onFileSelected: Failed to open",
                                      file);
                    }
                }

                function goToFolder(folder)
                {
                    memoryCardFolderToGo = folder;
                    flickableAnimation.restart();
                }
            }

            // Memory available space section
            Item{
                id: memoryAvailableItem
                width: parent.width
                height: childrenRect.height

                visible: false

                Column{
                    width: parent.width

                    ListHeading {
                        id: listHeading
                        width: parent.width

                        ListItemText {
                            anchors.fill: listHeading.paddingItem
                            role: "Heading"
                            text: "Memory Available"
                        }
                    }

                    // Phone memory free and total space item
                    ListItem {

                        Column {
                            anchors.fill: parent.paddingItem
                            width: parent.width

                            ListItemText {
                                role: "Title"
                                text: fileHelper.phoneMemoryImagesPath[0] + " (Phone memory)"
                            }

                            ListItemText {
                                role: "SubTitle"
                                text: fileHelper.phoneMemoryFreeAndTotalSpace()
                            }
                        }
                    }

                    // Memory card free and total space item
                    ListItem {
                        visible: memoryCardPresent

                        Column {
                            anchors.fill: parent.paddingItem
                            width: parent.width

                            ListItemText {
                                role: "Title"
                                text: fileHelper.memoryCardImagesPath[0] + " (Mass memory)"
                            }

                            // Sub title displaying the size and the date
                            ListItemText {
                                role: "SubTitle"
                                text: fileHelper.memoryCardFreeAndTotalSpace()
                            }
                        }
                    }
                }
            }
        }
    }

    Timer{
        id: delayTimer
        interval: 500

        onTriggered: {
            console.log("timer triggered");
            fadeInAnimation.start();
        }
    }

    // fade in/out animation
    SequentialAnimation {
        id: flickableAnimation

        PropertyAnimation {
            target: flick
            property: "opacity"; to: 0;
            duration: Constants.DEFAULT_ANIM_DURATION
        }

        PropertyAction{
            target: phoneMemoryFolderList
            property: "folder"
            value: phoneMemoryFolderToGo
        }

        PropertyAction{
            target: memoryCardFolderList
            property: "folder"
            value: memoryCardFolderToGo
        }

        PropertyAction{
            targets: phoneMemoryFolderList
            property: "showNoFilesItem"
            value: true
        }

        PropertyAction{
            target: memoryCardFolderList
            property: "showNoFilesItem"
            value: true
        }

        PropertyAction{
            targets: [phoneMemoryFolderList, memoryAvailableItem]
            property: "visible"
            value: true
        }

        PropertyAction{
            targets: memoryCardFolderList
            property: "visible"
            value: memoryCardPresent ? true : false
        }

        onCompleted:{
            console.log("Sequential animation completed");
            delayTimer.start();
            console.log("Memory card present: " + memoryCardPresent);
        }
    }

    PropertyAnimation {
        id: fadeInAnimation
        target: flick
        property: "opacity"; to: 1.0;
        duration: Constants.DEFAULT_ANIM_DURATION
    }

    Component.onCompleted: {
        console.log("Component completed");

        // Navigate to images folders in the start-up.
        var path = fileHelper.pathUrl(fileHelper.phoneMemoryImagesPath);
        phoneMemoryFolderList.goToFolder(path);

        memoryCardPresent = fileHelper.memoryCardPresent

        if(memoryCardPresent){
            path = fileHelper.pathUrl(fileHelper.memoryCardImagesPath);
            memoryCardFolderList.goToFolder(path);
        }
        else
            memoryCardFolderList.visible = false;

        initialized = true;
    }

    onStatusChanged: {
        if(status == PageStatus.Active){
            switch (contentType)
            {
            case Constants.ContentType.Images:
                buttonsRow.checkedButton = imagesButton;;
                break;
            case Constants.ContentType.Sounds:
                buttonsRow.checkedButton = soundsButton;
                break;
            case Constants.ContentType.Videos:
                buttonsRow.checkedButton = videosButton;
                break;
            }
        }
    }
}


// End of file.
