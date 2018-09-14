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
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.0

ColumnLayout {
    spacing: app.spacing

    RowLayout {
        spacing: app.spacing
        Layout.fillWidth: true

        Label {
            font.pixelSize: 24
            text: qsTr("Settings")
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            text: qsTr("Reset")
            icon.source: "qrc:/icons/reset.svg"
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Universal.background

        border {
            width: 2
            color: "#858585"
        }

        RowLayout {
            spacing: 2 * app.spacing
            anchors.centerIn: parent

            GridLayout {
                columns: 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                rowSpacing: app.spacing
                columnSpacing: app.spacing

                Label {
                    text: qsTr("Baud Rate")
                } ComboBox {
                    currentIndex: 3
                    model: [
                        "1200",
                        "2400",
                        "4800",
                        "9600",
                        "19200",
                        "38400",
                        "57600",
                        "15200",
                    ]
                }

                Label {
                    text: qsTr("Data Bits")
                } ComboBox {
                    model: [ 5, 6, 7, 8]
                }

                Label {
                    text: qsTr("Parity")
                } ComboBox {
                    model: [
                        qsTr("No Parity"),
                        qsTr("Even Parity"),
                        qsTr("Odd Parity"),
                        qsTr("Space Parity"),
                        qsTr("Mark Parity"),
                    ]
                }

                Label {
                    text: qsTr("Stop Bits")
                } ComboBox {
                    model: [
                        qsTr("One Stop"),
                        qsTr("One and Half Stop"),
                        qsTr("Two Stop")
                    ]
                }
            }

            ColumnLayout {
                spacing: app.spacing
                Layout.fillWidth: true
                Layout.fillHeight: true

                CheckBox {
                    text: qsTr("Save received data to disk")
                    checked: CSerialManager.fileLoggingEnabled
                    onCheckedChanged: CSerialManager.fileLoggingEnabled = checked
                }

                CheckBox {
                    checked: CDataParser.csvLoggingEnabled
                    text: qsTr("Save sensor readings to CSV file")
                    onCheckedChanged: CDataParser.csvLoggingEnabled = checked
                }

                CheckBox {
                    checked: false
                    text: qsTr("Full-Screen UI")
                    onCheckedChanged: {
                        if (checked)
                            app.showFullScreen()
                        else
                            app.showNormal()
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}

