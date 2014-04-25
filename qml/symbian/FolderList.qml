/**
 * Copyright (c) 2011-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import Qt.labs.folderlistmodel 1.0
import "SymbianUIConstants.js" as Constants

Item {
    id: folderList

    height: childrenRect.height

    property alias modelView: folderModelView
    property alias folder: folderModel.folder
    property alias parentFolder: folderModel.parentFolder
    property alias showDirs: folderModel.showDirs
    property alias count: folderModelView.count
    property alias contentOpacity: folderModelView.opacity
    property alias listInteractive: folderModelView.interactive
    property bool showNoFilesItem: false
    property bool isE6: (root.width == 480 || root.height == 480)

    signal folderSelected(variant folder)
    signal fileSelected(variant file)
    signal folderStructureLoaded()

    // FolderListModel is not visible item.
    FolderListModel {
        id: folderModel
    }

    ListHeading {
        id: listHeading
        anchors.top: parent.top
        width: parent.width

        ListItemText {
            anchors.fill: listHeading.paddingItem
            role: "Heading"
            text: fileHelper.urlToLocalFile(folderModel.folder)
        }
    }

    ListItem {
        anchors.top: listHeading.bottom
        width: parent.width
        height: 70
        visible: folderModelView.visible && count == 0 && showNoFilesItem

        Label {
            id: noFilesText
            anchors.left: parent.paddingItem.left
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: platformStyle.fontSizeLarge
            text: "No files"
        }
    }

    // ListView presenting folders
    ListView {
        id: folderModelView
        width: parent.width
        anchors.top: listHeading.bottom

        model: folderModel
        height: isE6 ? Constants.LIST_ITEM_DEFAULT_HEIGHT_E6 * count :
                       Constants.LIST_ITEM_DEFAULT_HEIGHT * count;
        interactive: false

        delegate: ListItem {
            id: listItem
            height: isE6 ? Constants.LIST_ITEM_DEFAULT_HEIGHT_E6 :
                           Constants.LIST_ITEM_DEFAULT_HEIGHT;
            subItemIndicator: folderModel.isFolder(index)

            ListItemText {
                id: title

                anchors.left: parent.paddingItem.left
                anchors.top: parent.paddingItem.top

                mode: listItem.mode
                role: "Title"
                text: fileName
            }

            // Sub title displaying the size and the date
            ListItemText {
                id: subtitle

                anchors.left: parent.paddingItem.left
                anchors.top: title.bottom

                mode: listItem.mode
                role: "SubTitle"
                text: buildSubTitleText();
            }

            ListItemText {
                anchors.right: parent.paddingItem.right
                anchors.verticalCenter: subtitle.verticalCenter

                mode: listItem.mode
                role: "SubTitle"
                text: folderModel.isFolder(index) ? "" : fileHelper.size(filePath)
            }


            function buildSubTitleText(){
                var text;
                text = fileHelper.created(filePath);

                if(folderModel.isFolder(index) && fileHelper.isDirEmpty(filePath)){
                        text += "  (empty)";
                }

                return text;
            }

            onClicked: {
                console.log("Item clicked");

                if (fileName.length) {
                    if (folderModel.isFolder(index)) {
                        folderList.folderSelected(filePath);
                    }
                    else {
                        folderList.fileSelected(filePath);
                    }
                }
            }
        }
    }

    onFolderChanged: {
        console.log("Folder changed to: " + folder);
    }

    onCountChanged: {
        if(folder != "")
            folderStructureLoaded()
    }
}

// End of file.
