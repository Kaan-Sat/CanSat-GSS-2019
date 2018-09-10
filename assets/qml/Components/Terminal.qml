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

Item {
    //
    // Custom properties
    //
    property int scrollback: 100
    property alias text: textArea.text
    property alias textContainer: textArea
    property alias autoScroll: autoScrollCheckbox.checked

    //
    // Appends the given string to the text and scrolls
    // the view to the bottom
    //
    function append (str) {
        text += str

        if (autoScroll)
            textContainer.cursorPosition = text.length
    }

    //
    // Clears the current buffer
    //
    function clear() {
        text = ""
    }

    //
    // Removes previous lines to avoid running out of RAM
    //
    onTextChanged: {
        if (textContainer.lineCount > scrollback)
            text = text.split ("\n").slice (1).join ("\n")
    }

    //
    // Widgets
    //
    ColumnLayout {
        anchors.fill: parent

        //
        // Control widgets
        //
        RowLayout {
            Layout.fillWidth: true

            CheckBox {
                checked: true
                id: autoScrollCheckbox
                text: qsTr ("Auto-scroll")
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                onClicked: clear()
                icon.source: "qrc:/icons/clear.svg"
            }

            Button {
                icon.source: "qrc:/icons/open.svg"
                onClicked: CSerialManager.openDataFile()
            }
        }

        //
        // Text widget
        //
        RowLayout {
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    id: textArea
                    readOnly: true
                    font.family: "Hack"
                    anchors.fill: parent
                    color: Universal.accent
                }
            }
        }
    }

    //
    // Place holder label
    //
    Label {
        font.bold: true
        font.pixelSize: 18
        anchors.centerIn: parent
        visible: textArea.text.length == 0
        text: qsTr ("No data received so far") + "..."
    }
}
