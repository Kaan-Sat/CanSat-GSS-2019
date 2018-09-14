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
import QtLocation 5.11
import QtPositioning 5.11
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Universal 2.0

ColumnLayout {
    spacing: app.spacing
    Component.onCompleted: centerMap()

    //
    // Will be true if GPS coordinates are different from (0,0)
    //
    readonly property bool gpsWorking: CDataParser.gpsLatitude !== 0 ||
                                       CDataParser.gpsLongitude !== 0

    //
    // Location of Queretaro (aguacatosas!!!)
    //
    readonly property var qroCoordinates: QtPositioning.coordinate(
                                              20.5846129, -100.385372)

    //
    // Real-time position
    //
    readonly property var gpsCoordinates: QtPositioning.coordinate(
                                              CDataParser.gpsLatitude,
                                              CDataParser.gpsLongitude)

    //
    // Center map when connecting with CanSat
    //
    Connections {
        target: CSerialManager
        onConnectionSuccess: centerMap()
    }

    //
    // Centers the map to Queretaro if the GPS is not working,
    // otherwise, centers the map to the CanSat's position
    //
    function centerMap() {
        // GPS not responding, go to QRO
        if (!gpsWorking) {
            map.center = qroCoordinates
            map.zoomLevel = (map.minimumZoomLevel + map.maximumZoomLevel) / 2
        }

        // Show GPS position
        else {
            map.center = gpsCoordinates
            map.zoomLevel = map.maximumZoomLevel - 2
        }
    }

    //
    // Controls
    //
    RowLayout {
        spacing: app.spacing
        Layout.fillWidth: true

        Label {
            font.pixelSize: 24
            text: qsTr("GPS Map")
        }

        Item {
            Layout.fillWidth: true
        }

        ComboBox {
            Layout.preferredWidth: 250

            textRole: "description"
            model: map.supportedMapTypes
            Component.onCompleted: currentIndex = 5
            onCurrentIndexChanged: map.activeMapType = map.supportedMapTypes[currentIndex]
        }

        Button {
            text: qsTr("Re-center")
            icon.source: "qrc:/icons/location.svg"
            onClicked: centerMap()
        }
    }

    //
    // Map
    //
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Universal.background

        border {
            width: 2
            color: "#858585"
        }

        Map {
            id: map
            anchors.fill: parent
            copyrightsVisible: false
            color: Universal.background
            anchors.margins: parent.border.width

            MapQuickItem {
                sourceItem: Rectangle {
                    width: 20
                    height: 20
                    color: "#f00"
                    border.width: 2
                    radius: width / 2
                    border.color: "#fff"
                }

                coordinate: gpsWorking ? gpsCoordinates : qroCoordinates
                anchorPoint: Qt.point(sourceItem.width / 2,
                                      sourceItem.height/ 2)
            }

            plugin: Plugin {
                name: "mapboxgl"
            }
        }
    }
}

