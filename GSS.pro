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

TARGET = GSS
TEMPLATE = app

CONFIG += qtc_runnable
CONFIG += resources_big

QT += xml
QT += svg
QT += core
QT += quick
QT += widgets
QT += serialport
QT += quickcontrols2

QTPLUGIN += qsvg

#-------------------------------------------------------------------------------
# Import source code
#-------------------------------------------------------------------------------

HEADERS += \
    src/AppInfo.h \
    src/DataParser.h \
    src/SerialManager.h \
    src/crc32.h

SOURCES += \
    src/DataParser.cpp \
    src/main.cpp \
    src/SerialManager.cpp \
    src/crc32.c

DISTFILES += \
    assets/qml/Components/ComConsole.qml \
    assets/qml/Components/DataGrid.qml \
    assets/qml/Components/GPS.qml \
    assets/qml/Components/Overview.qml \
    assets/qml/Components/Terminal.qml \
    assets/qml/Modules/Configuration.qml \
    assets/qml/Modules/CsvData.qml \
    assets/qml/Modules/Logger.qml \
    assets/qml/Modules/MisionData.qml \
    assets/qml/main.qml \
    assets/qml/UI.qml

RESOURCES += \
    assets/qml/qml.qrc \
    assets/images/images.qrc \
    assets/icons/icons.qrc
