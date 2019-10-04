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
import QtCharts 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Universal 2.0

import "../Components"

Rectangle {
    color: "transparent"
    border {
        width: 2
        color: "#858585"
    }

    //
    // Background rectangle
    //
    Rectangle {
        opacity: 0.75
        anchors.fill: parent
        color: Universal.background
        anchors.margins: parent.border.width
    }

    //
    // Main layout
    //
    RowLayout {
        spacing: app.spacing

        //
        // Anchors
        //
        anchors {
            fill: parent
            margins: app.spacing
        }

        //
        // GPS Map & Terminal
        //
        ColumnLayout {
            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.margins: app.spacing

            GroupBox {
                Layout.margins: 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.family: app.monoFont
                title: "// " + qsTr("GPS Map & Raw Frame Data")

                background: Rectangle {
                    color: "#000"
                    opacity: 0.75
                    border.width: 2
                    anchors.fill: parent
                    anchors.topMargin: 32
                    border.color: "#858585"
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: app.spacing

                    GPS {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Terminal {
                        opacity: 0.75
                        Layout.margins: 0
                        Layout.fillWidth: true
                        Layout.minimumHeight: 196
                    }
                }
            }
        }

        //
        // Sensor readings
        //
        DataGrid {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: app.spacing
        }
    }
}

