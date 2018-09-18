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

RowLayout {
    property string title: ""
    property string units: ""
    property string dataset: ""

    spacing: app.spacing
    Layout.fillWidth: true
    Layout.fillHeight: true

    Item {
        Layout.fillWidth: true
    }

    Label {
        color: "#72d5a3"
        text: title + ":"
        font.pixelSize: 12
        Layout.fillWidth: false
        Layout.fillHeight: true
        font.family: app.monoFont
        horizontalAlignment: Label.AlignRight
    }

    Label {
        color: "#72d5a3"
        font.pixelSize: 12
        Layout.fillWidth: false
        Layout.fillHeight: true
        font.family: app.monoFont
        textFormat: Text.RichText
        horizontalAlignment: Label.AlignHCenter
        Layout.minimumWidth: font.pixelSize * 5
        text: CSerialManager.connected ? dataset + " " + units : "--.--"
    }
}
