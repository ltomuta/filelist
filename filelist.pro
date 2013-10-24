# Copyright (c) 2011-2012 Nokia Corporation.

QT += core gui declarative
CONFIG += mobility qt-components
MOBILITY += systeminfo

TARGET = filelist
VERSION = 1.1

HEADERS += \
    src/filehelper.h

SOURCES += \
    src/main.cpp \
    src/filehelper.cpp

RESOURCES += rsc/common.qrc

symbian {
    TARGET = FileListQML
    TARGET.UID3 = 0xE63A97B4
    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x1000 0x1800000 # 24MB

    LIBS += -lPlatformEnv -lefsrv

    OTHER_FILES += \
        qml/symbian/*.qml \
        qml/symbian/SymbianUIConstants.js

    qmlfiles.sources = qml
    DEPLOYMENT += qmlfiles

    ICON = icons/filelist.svg
}

simulator {
    OTHER_FILES += \
        qml/symbian/*.qml \
        qml/symbian/SymbianUIConstants.js

    # Modify the following path if necessary
    SHADOW_BLD_PATH = ..\\filelist-build-simulator-Simulator_Qt_for_MinGW_4_4__Qt_SDK__Debug

    system(mkdir $${SHADOW_BLD_PATH}\\qml\\symbian)
    system(copy qml\\symbian\\*.* $${SHADOW_BLD_PATH}\\qml\\symbian)
}

# End of file.
