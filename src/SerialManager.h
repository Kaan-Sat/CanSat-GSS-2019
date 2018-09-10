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

#ifndef SERIAL_MANAGER_H
#define SERIAL_MANAGER_H

#include <QtQml>
#include <QObject>

class QSerialPort;

class SerialManager : public QObject {
    Q_OBJECT

    Q_PROPERTY (bool connected
                READ connected
                NOTIFY connectionChanged)
    Q_PROPERTY (QString receivedBytes
                READ receivedBytes
                NOTIFY dataReceived)
    Q_PROPERTY (QStringList serialDevices
                READ serialDevices
                NOTIFY serialDevicesChanged)

signals:
    void connectionChanged();
    void serialDevicesChanged();
    void dataReceived (const QString& data);
    void connectionError (const QString& deviceName);
    void connectionSuccess (const QString& deviceName);

public:
    static SerialManager* getInstance();
    bool connected() const;
    QString receivedBytes() const;
    QStringList serialDevices() const;

public slots:
    void openDataFile();
    void startComm (const int device);

private slots:
    void onDataReceived();
    void disconnectDevice();
    void configureLogFile();
    void refreshSerialDevices();

private:
    SerialManager();
    ~SerialManager();
    QString sizeStr (const quint64 bytes) const;

private:
    QFile m_file;
    QSerialPort* m_port;
    QStringList m_serialDevices;
};

#endif
