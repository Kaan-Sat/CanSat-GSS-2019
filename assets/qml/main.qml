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
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Universal 2.0

ApplicationWindow {
    id: app

    //
    // Application constants
    //
    readonly property int spacing: 8

    //
    // Window options
    //
    width: 800
    height: 600
    visible: true
    title: AppName + " - " + AppVersion

    //
    // Theme options
    //
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Orange

    //
    // Background control
    //
    background: Image {
        opacity: 0.4
        source: "qrc:/images/stars.jpg"
        fillMode: Image.PreserveAspectCrop

        Rectangle {
            opacity: 0.8
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 1
                    color: "#1CB5E0"
                }

                GradientStop {
                    position: 0
                    color: "#16222A"
                }
            }
        }
    }

    //
    // UI loader
    //
    Loader {
        opacity: 0
        asynchronous: true
        anchors.fill: parent
        onLoaded: opacity = 1

        sourceComponent: UI {
            anchors.fill: parent
            anchors.margins: app.spacing
        }

        Behavior on opacity { NumberAnimation {} }
    }
}
