#
# Copyright (c) 2018 Kaan-Sat <https://kaansat.com.mx/>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#-------------------------------------------------------------------------------
# Make options
#-------------------------------------------------------------------------------

UI_DIR = uic
MOC_DIR = moc
RCC_DIR = qrc
OBJECTS_DIR = obj

CONFIG += c++11

#-------------------------------------------------------------------------------
# Qt configuration
#-------------------------------------------------------------------------------

TEMPLATE = app
TARGET = cansat-gss

CONFIG += qtc_runnable
CONFIG += resources_big

QT += xml
QT += svg
QT += sql
QT += core
QT += quick
QT += location
QT += concurrent
QT += serialport
QT += positioning
QT += quickcontrols2

QTPLUGIN += qsvg

#-------------------------------------------------------------------------------
# Translations
#-------------------------------------------------------------------------------

TRANSLATIONS += \
    assets/translations/en.ts \
    assets/translations/es.ts

#-------------------------------------------------------------------------------
# Deploy options
#-------------------------------------------------------------------------------

win32* {
    RC_FILE = deploy/windows/resources/info.rc
}

macx* {
    ICON = deploy/mac-osx/icon.icns
    RC_FILE = deploy/mac-osx/icon.icns
    QMAKE_INFO_PLIST = deploy/mac-osx/info.plist
    QMAKE_POST_LINK = macdeployqt cansat-gss.app -qmldir=$$PWD/assets/qml
}

linux:!android {
    target.path = /usr/bin
    icon.path = /usr/share/pixmaps
    desktop.path = /usr/share/applications
    icon.files += deploy/linux/cansat-gss.png
    desktop.files += deploy/linux/cansat-gss.desktop

    INSTALLS += target desktop icon
}

#-------------------------------------------------------------------------------
# Import source code
#-------------------------------------------------------------------------------

HEADERS += \
    src/AppInfo.h \
    src/DataParser.h \
    src/SerialManager.h \
    src/crc32.h \
    src/Constants.h \
    src/AppQuiter.h \
    src/Translator.h

SOURCES += \
    src/DataParser.cpp \
    src/main.cpp \
    src/SerialManager.cpp \
    src/crc32.c \
    src/Translator.cpp

DISTFILES += \
    assets/qml/Components/ComConsole.qml \
    assets/qml/Components/DataGrid.qml \
    assets/qml/Components/Overview.qml \
    assets/qml/Components/Terminal.qml \
    assets/qml/Modules/Configuration.qml \
    assets/qml/Modules/CsvData.qml \
    assets/qml/Modules/Logger.qml \
    assets/qml/main.qml \
    assets/qml/UI.qml \
    assets/qml/Modules/Dashboard.qml \
    assets/qml/Modules/GpsMap.qml \
    assets/qml/Components/DataLabel.qml

RESOURCES += \
    assets/qml/qml.qrc \
    assets/images/images.qrc \
    assets/icons/icons.qrc \
    assets/fonts/fonts.qrc \
    assets/translations/translations.qrc
