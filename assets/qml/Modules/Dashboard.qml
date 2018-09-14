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

import "../Components"

ColumnLayout {
    spacing: app.spacing

    RowLayout {
        spacing: app.spacing
        Layout.fillWidth: true

        Label {
            font.pixelSize: 24
            text: qsTr("Dashboard")
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            text: qsTr("Reset Data")
            onClicked: CDataParser.resetData()
            icon.source: "qrc:/icons/reset.svg"
        }
    }

    Rectangle {
        id: rect
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Universal.background

        border {
            width: 2
            color: "#858585"
        }

        RowLayout {
            spacing: app.spacing

            anchors {
                fill: parent
                margins: app.spacing
            }

            Image {
                Layout.alignment: Qt.AlignVCenter
                source: "qrc:/images/satellite.svg"
                sourceSize: {
                    var length = Math.min(rect.height, rect.width) * 0.8
                    return Qt.size(length, length)
                }
            }

            DataGrid {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: app.spacing
            }
        }
    }
}
