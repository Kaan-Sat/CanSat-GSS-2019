/*
 * Copyright (c) 2018 Kaan-Sat <https://kaansat.com.mx/>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import "../Components"

ColumnLayout {
    RowLayout {
        Layout.fillWidth: true

        CheckBox {
            checked: true
            id: autoScrollCheck
            text: qsTr("Auto-scroll")
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            onClicked: terminal.clear()
            icon.source: "qrc:/icons/clear.svg"
        }

        Button {
            icon.source: "qrc:/icons/open.svg"
            onClicked: CSerialManager.openLogFile()
            enabled: CSerialManager.fileLoggingEnabled
        }
    }

    Terminal {
        id: terminal
        Layout.fillWidth: true
        Layout.fillHeight: true
        autoScroll: autoScrollCheck.checked

        Connections {
            target: CSerialManager
            onNewLineReceived: terminal.append(data)
        }
    }

    Label {
        Layout.alignment: Qt.AlignLeft
        text: qsTr("Data received: %1").arg(CSerialManager.receivedBytes)
    }
}

