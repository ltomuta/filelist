FileList
========

With the FileList example application, the user can explore the multimedia 
content (images, sounds, and videos) of a Symbian device. In addition, 
selected files can be opened with appropriate applications - for example, 
selecting an image from the file list will display the image in the Photos 
application. 

The application is compatible with Symbian phones and requires Qt 4.7.4,
Qt Mobility 1.2.1 and Qt Quick Components 1.1 for Symbian.

Visit the project web page for more information:
http://projects.developer.nokia.com/filelist

This example application demonstrates:
- Browsing Symbian filesystem with Qt Quick
- Opening files in external applications
- An animated splash screen

For more information on implementation, visit the wiki pages:
- http://projects.developer.nokia.com/filelist/wiki

What's new in version 1.1
-------------------------
- The interactive header was removed and the file models of both the phone
  memory and a memory card were combined to a single view.
- A splash screen was added.
- Qt Quick Components were updated to version 1.1


1. Prerequisites
-------------------------------------------------------------------------------

 - Qt basics
 - Qt Quick basics


2. Project structure and implementation
-------------------------------------------------------------------------------

2.1 Folders
-----------

 |                  The root folder contains the project file, resource files,
 |                  the license information and this file (release notes).
 |
 |- bin             Contains the installable Symbian binary files.
 |
 |- gfx             Contains application graphics.
 |
 |- icons           Contains application icons.
 |
 |- qml             Root folder for QML and JavaScript files.
 |  |
 |  |- symbian      Symbian specific QML and JavaScript files.
 |
 |- rsc             Contains the files for Qt resource system.
 |
 |- src             Contains the Qt/C++ source code files.


2.2 Important files and classes
-------------------------------

| File                              | Description                                |
|-----------------------------------|--------------------------------------------|
| src/filehelper.h                  | The FileHelper class is a utility class    |
| src/filehelper.cpp                | providing convenient methods which can be  |
|                                   | accessed within the QML code.              |
|-----------------------------------|--------------------------------------------|
| qml/symbian/CustomProgressBar.qml | Custom ProgressBar implementation.         |
|                                   |                                            |
|-----------------------------------|--------------------------------------------|
| qml/symbian/FileListPage.qml      | The main view of the application.          |
|                                   |                                            |
|-----------------------------------|--------------------------------------------|
| qml/symbian/FolderList.qml        | The folder list element, provides the      |
|                                   | visible folder list item and JavaScript    |
|                                   | functions for controls.                    |
|-----------------------------------|--------------------------------------------|
| qml/symbian/MainApp.qml           | The main QML file composing the page stack |
|                                   | component.                                 |
|-----------------------------------|--------------------------------------------|
| qml/symbian/MainAppLoader.qml     | The element loaded during the application  |
|                                   | start-up. Shows the splash screen and      |
|                                   | loads the main application content.        |
|-----------------------------------|--------------------------------------------|
| qml/symbian/SplashScreen.qml      | The splash screen QML file.                |
|-----------------------------------|--------------------------------------------|
| qml/symbian/SubFolderPage.qml     | The sub folder page QML file. Provides     |
|                                   | sub folder content list.                   |
|-----------------------------------|--------------------------------------------|

| Class                   | Description                                       |
|-------------------------|---------------------------------------------------|
| QDesktopServices        | Used to open files with external applications.    |
|-------------------------|---------------------------------------------------|
| QSystemStorageInfo      | Used to get information about device storage.     |
|-------------------------|---------------------------------------------------|
| PathInfo                | Provides paths to multimedia folders.             |
|-------------------------|---------------------------------------------------|

2.3 Used APIs/QML elements/Qt Quick Components
----------------------------------------------

 FolderListModel - The model containing the folder data of the filesystem. This
                   is an experimental component from Qt.labs module.
 PageStackWindow - The application window containing the status bar, tool bar
                   and the page stack. This is the root element of the
                   application UI.


3. Compatibility
-------------------------------------------------------------------------------

 - Symbian phones with Qt 4.7.4, Qt Mobility 1.2.1 and Qt Quick Components 1.1.

Tested to work on Nokia C7-00, Nokia E6-00, Nokia E7-00, Nokia N8-00 and
Nokia X7-00. Developed with Qt SDK 1.2.

3.1 Required capabilities
-------------------------

None; the application can be self signed on Symbian.

3.2 Known issues
----------------

None.


4. Building, installing, and running the application
-------------------------------------------------------------------------------

4.1 Preparations
----------------

Check that you have the latest Qt SDK installed in the development environment
and the latest Qt version on the device.

Qt Quick Components 1.1 or higher is required.

4.2 Using the Qt SDK
--------------------

You can install and run the application on the device by using the Qt SDK.
Open the project in the SDK, set up the correct target (depending on the device
platform), and click the Run button. For more details about this approach,
visit the Qt Getting Started section at Nokia Developer
(http://www.developer.nokia.com/Develop/Qt/Getting_started/).

4.3 Symbian device
------------------

Make sure your device is connected to your computer. Locate the .sis
installation file and open it with Nokia Suite. Accept all requests from Nokia
Suite and the device. Note that you can also install the application by copying
the installation file onto your device and opening it with the Symbian File
Manager application.

After the application is installed, locate the application icon from the
application menu and launch the application by tapping the icon.


5. License
-------------------------------------------------------------------------------

See the license text file delivered with this project. The license file is also
available online at
http://projects.developer.nokia.com/filelist/browser/Licence.txt


6. Related documentation
-------------------------------------------------------------------------------
Qt Quick Components
- http://doc.qt.nokia.com/qt-components-symbian-1.1/index.html


7. Version history
-------------------------------------------------------------------------------

1.1.1 Disk space related bug fixed
1.1 Improvements to the user experience
1.0 Initial release
