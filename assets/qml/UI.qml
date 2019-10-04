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
import QtQuick.Controls 2.3
import QtQuick.Controls.Universal 2.0

import "Modules"

ColumnLayout {
    id: ui
    spacing: app.spacing

    //
    // Toolbar
    //
    RowLayout {
        spacing: 0
        Layout.fillWidth: true

        //
        // Logo
        //
        ColumnLayout {
            spacing: app.spacing

            Image {
                opacity: 0.8
                sourceSize.width: 240
                source: "qrc:/images/kaansat.svg"
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                opacity: 0.6
                font.pixelSize: 10
                text: AppName + " v" + AppVersion
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.fillWidth: true
        }

        //
        // Serial port selector
        //
        ComboBox {
            id: devices
            Layout.preferredWidth: 156
            model: CSerialManager.serialDevices
            enabled: CSerialManager.serialDevices.length > 1
            onCurrentIndexChanged: CSerialManager.startComm(currentIndex)
        }

        //
        // Spacer
        //
        Item {
            width: app.spacing
        }

        //
        // Baud rate selector
        //
        ComboBox {
            id: baudRate
            currentIndex: 3
            onCurrentIndexChanged: CSerialManager.setBaudRate(model[currentIndex])

            model: [
                1200,
                2400,
                4800,
                9600,
                19200,
                38400,
                57600,
                15200,
            ]
        }

        //
        // Spacer
        //
        Item {
            width: app.spacing
        }

        //
        // CSV table button
        //
        Button {
            background: Item {}

            Rectangle {
                width: 32
                height: 32
                radius: width / 2
                anchors.centerIn: parent
                color: Qt.rgba(35/255, 209/255, 75/255, 1)

                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.21)
            }

            icon.source: "qrc:/icons/csv.svg"
            icon.color: Qt.rgba(0, 0, 0, 0.42)
            onClicked: CDataParser.openCsvFile()
        }

        //
        // Spacer
        //
        Item {
            width: app.spacing
        }

        //
        // Full screen button
        //
        Button {
            background: Item {}

            Rectangle {
                width: 32
                height: 32
                radius: width / 2
                anchors.centerIn: parent
                color: Qt.rgba(229/255, 193/255, 58/255, 1)

                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.21)
            }

            checkable: true
            icon.color: Qt.rgba(0, 0, 0, 0.42)
            onClicked: checked ? app.showFullScreen() : app.showNormal()
            icon.source: checked ? "qrc:/icons/fullscreen-exit.svg" :
                                   "qrc:/icons/fullscreen.svg"
        }

        //
        // Spacer
        //
        Item {
            width: app.spacing
        }

        //
        // Close button
        //
        Button {
            background: Item {}

            Rectangle {
                width: 32
                height: 32
                radius: width / 2
                anchors.centerIn: parent
                color: Qt.rgba(246/255, 82/255, 82/255, 1)

                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.21)
            }

            onClicked: app.close()
            icon.source: "qrc:/icons/exit.svg"
            icon.color: Qt.rgba(0, 0, 0, 0.42)
        }
    }

    //
    // Dashboard
    //
    Dashboard {
        id: dashboard
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    //
    // Connection status dialog
    //
    Dialog {
        id: dialog

        //
        // Only close the dialog when the user
        // presses on the 'OK' button
        //
        modal: true
        standardButtons: Dialog.Ok
        closePolicy: Dialog.NoAutoClose

        //
        // Center dialog on app window
        //
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        //
        // Set min. width to 320 pixels
        //
        width: Math.max(implicitWidth, 320)

        //
        // Used to select <None> after the user closes
        // this dialog (only in the case that we could not
        // connect to the serial device)
        //
        property bool error: false
        onAccepted: {
            if (error)
                devices.currentIndex = 0
        }

        //
        // Message description
        //
        Label {
            id: description
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            horizontalAlignment: Qt.AlignLeft
        }

        //
        // Show dialog when serial device connection status changes
        //
        Connections {
            target: CSerialManager

            onConnectionError: {
                dialog.error = true
                dialog.title = qsTr("Warning")
                description.text = qsTr("Disconnected from \"%1\"").arg(deviceName)
                dialog.open()
            }
        }
    }
}

