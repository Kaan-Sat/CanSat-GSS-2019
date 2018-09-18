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
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0

import Qt.labs.settings 1.0

ApplicationWindow {
    id: app

    //
    // Application constants
    //
    readonly property int spacing: 8
    readonly property string invalidData: "--.--"
    readonly property string monoFont: loader.name

    //
    // Window options
    //
    x: 100
    y: 100
    title: AppName
    minimumWidth: 1024
    minimumHeight: 680
    width: minimumWidth
    height: minimumHeight

    //
    // Guardar posición y tamaño de la ventana automáticamente
    //
    Settings {
        property alias _x: app.x
        property alias _y: app.y
        property alias _w: app.width
        property alias _h: app.height
    }

    //
    // Ask user if he/she wants to exit app
    //
    onClosing: {
        close.accepted = false
        dialog.open()
    }

    //
    // Theme options
    //
    Material.theme: Material.Dark
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Amber

    //
    // Mono font loader
    //
    FontLoader {
        id: loader
        source: "qrc:/fonts/source-code-pro.ttf"
    }

    //
    // UI module
    //
    UI {
        anchors.fill: parent
        anchors.margins: app.spacing
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
        closePolicy: Dialog.NoAutoClose
        standardButtons: Dialog.Yes | Dialog.No

        //
        // Close the application when user clicks on 'yes' button
        //
        onAccepted: CAppQuiter.closeApplication()

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
        // Message description
        //
        title: qsTr("Exit confirmation")
        Label {
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            horizontalAlignment: Qt.AlignLeft
            text: qsTr("Are you sure you want to exit %1?").arg(AppName)
        }
    }
}
