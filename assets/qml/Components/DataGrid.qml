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

GridLayout {
    id: dataGrid

    columns: 2
    rowSpacing: app.spacing
    columnSpacing: app.spacing

    //
    // Mission status
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("Mission Status")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            DataLabel {
                title: qsTr("Mission Time")
                dataset: {
                    function pad(n) {
                        return (n < 10) ? ("0" + n) : n;
                    }

                    var milliseconds = CDataParser.missionTime
                    var seconds = (milliseconds / 1000)
                    var minutes = (seconds / 60) % 60

                    seconds = seconds % 60
                    milliseconds = milliseconds % 1000

                    seconds = Math.round(seconds)
                    minutes = Math.round(minutes)
                    milliseconds = Math.round(milliseconds)

                    return pad(minutes) + ":"
                            + pad(seconds) + "."
                            + milliseconds.toString()[0]
                }
            }

            DataLabel {
                title: qsTr("Team ID")
                dataset: CDataParser.teamId
            }

            DataLabel {
                title: qsTr("Checksum")
                dataset: (CDataParser.checksum).toString(16)
            }
        }
    }

    //
    // Misc. sensors
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("Sensor Readings")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            anchors.centerIn: parent

            DataLabel {
                units: "m"
                title: qsTr("Altitude")
                dataset: CDataParser.altitude
            }

            DataLabel {
                units: "ATM"
                title: qsTr("Pressure")
                dataset: CDataParser.atmosphericPressure
            }

            DataLabel {
                units: "°C"
                title: qsTr("Temperature")
                dataset: CDataParser.temperature
            }

            DataLabel {
                title: qsTr("Relative Humidity")
                dataset: CDataParser.relativeHumidity + "%"
            }

            DataLabel {
                title: qsTr("UV Index")
                dataset: CDataParser.uvRadiationIndex
            }
        }
    }

    //
    // Accelerometer
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("Accelerometer")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            DataLabel {
                title: "X"
                units: "m/s<sup>2</sup>"
                dataset: CDataParser.accelerometer.x
            }

            DataLabel {
                title: "Y"
                units: "m/s<sup>2</sup>"
                dataset: CDataParser.accelerometer.y
            }

            DataLabel {
                title: "Z"
                units: "m/s<sup>2</sup>"
                dataset: CDataParser.accelerometer.z
            }
        }
    }

    //
    // Gyroscope
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("Gyroscope")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            DataLabel {
                title: "X"
                units: "rad/s"
                dataset: CDataParser.gyroscope.x
            }

            DataLabel {
                title: "Y"
                units: "rad/s"
                dataset: CDataParser.gyroscope.y
            }

            DataLabel {
                title: "Z"
                units: "rad/s"
                dataset: CDataParser.gyroscope.z
            }
        }
    }

    //
    // GPS
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("GPS")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            DataLabel {
                units: "m"
                title: qsTr("Altitude")
                dataset: CDataParser.gpsAltitude
            }

            DataLabel {
                units: "m/s"
                title: qsTr("Velocity")
                dataset: CDataParser.gpsVelocity
            }

            DataLabel {
                title: qsTr("Latitude")
                dataset: CDataParser.gpsLatitude
            }

            DataLabel {
                title: qsTr("Longitude")
                dataset: CDataParser.gpsLongitude
            }

            DataLabel {
                title: qsTr("Satellites")
                dataset: CDataParser.gpsSatelliteCount
            }

            DataLabel {
                title: qsTr("GPS Time")
                dataset: CDataParser.gpsTime
            }
        }
    }

    //
    // Satellite health & comm. status
    //
    GroupBox {
        font.family: app.monoFont
        title: "// " + qsTr("Satellite Health")
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            spacing: app.spacing
            anchors.centerIn: parent

            DataLabel {
                units: "V"
                title: qsTr("Voltage")
                dataset: CDataParser.voltage
            }

            DataLabel {
                title: qsTr("Resets")
                dataset: CDataParser.resetCount
            }

            DataLabel {
                title: qsTr("Packet Errors")
                dataset: CDataParser.errorCount
            }

            DataLabel {
                title: qsTr("Packets Parsed")
                dataset: CDataParser.successCount
            }
        }
    }
}

