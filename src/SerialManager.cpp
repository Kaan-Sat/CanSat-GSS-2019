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

#include <QDir>
#include <QFile>
#include <QTimer>
#include <QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDesktopServices>

#include "SerialManager.h"

static SerialManager* instance = Q_NULLPTR;

SerialManager::SerialManager() {
    // Ensure that we do not have issues with the serial port pointer
    m_port = Q_NULLPTR;

    // Search for new serial devices
    refreshSerialDevices();

    // Create/close log file when the connection state with a serial device is
    // changed
    connect (this, SIGNAL(connectionChanged()), this, SLOT(configureLogFile()));
}

SerialManager::~SerialManager() {
    // Close serial device comm. channel
    if (m_port)
        m_port->close();

    // Close log file
    if (m_file.isOpen())
        m_file.close();
}

SerialManager* SerialManager::getInstance() {
    // This is the first time that the program calls this function,
    // create a new instance of the class
    if (instance == Q_NULLPTR)
        instance = new SerialManager();

    // Return instance pointer
    return instance;
}

bool SerialManager::connected() const  {
    // Return connection status with current serial port
    if (m_port)
        return m_port->isOpen();

    // Port is closed/invalid
    return false;
}

QString SerialManager::receivedBytes() const {
    // Only return received/saved bytes if port is open and file exists
    if (m_port) {
        if (!m_file.fileName().isEmpty() && m_port->isOpen())
            return sizeStr (m_file.size());
    }

    // Return 0 bytes if above conditions are not met
    return "0 " + tr ("bytes");
}

QStringList SerialManager::serialDevices() const {
    return m_serialDevices;
}

void SerialManager::openDataFile() {
    if (!m_file.fileName().isEmpty())
        QDesktopServices::openUrl (QUrl::fromLocalFile (m_file.fileName()));
}

void SerialManager::startComm (const int device) {
    // Disconnect current serial port device
    disconnectDevice();

    // Ignore the <None> virtual device
    if (device > 0) {
        // Get 'real' port ID
        int portId = device - 1;
        QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();

        // Check if port ID is valid
        if (portId < ports.count()) {
            // Configure new serial port device
            m_port = new QSerialPort (ports.at (portId));
            m_port->setBaudRate (9600);

            // Connect signals/slots
            connect (m_port, SIGNAL (readyRead()), this, SLOT (onDataReceived()));
            connect (m_port, SIGNAL (aboutToClose()), this, SLOT (disconnectDevice()));

            // Try to open the serial port device
            if (m_port->open (QIODevice::ReadOnly)) {
                emit connectionChanged();
                emit connectionSuccess (m_port->portName());
            }

            // There was an error opening the serial port device
            else
                disconnectDevice();
        }

        // Port ID is invalid
        else
            emit connectionError ("Invalid");
    }
}

void SerialManager::onDataReceived() {
    // Check serial port pointer
    if (!m_port)
        return;

    // Read incoming data
    QString data = QString::fromUtf8 (m_port->readAll());

    // Write received data to log file
    if (m_file.open (QFile::Append)) {
        m_file.write (data.toUtf8());
        m_file.close();
    }

    // Send data to UI and other app modules
    emit dataReceived (data);
}

/**
 * Closes the comm. channel with the current serial device and notifies
 * the rest of the application modules, so that the following tasks can
 * be performed:
 *     - Close the current log/received data file
 *     - Update the user interface
 *     - Disconnect serial device signals/slots to the SerialManager
 */
void SerialManager::disconnectDevice() {
    // Check if serial port pointer is valid
    if (m_port) {
        // Get serial port name
        QString name = m_port->portName();

        // Disconnect signals/slots of serial port
        m_port->disconnect (this, SLOT (onDataReceived()));
        m_port->disconnect (this, SLOT (disconnectDevice()));

        // Close and delete the serial port
        m_port->close();
        m_port->deleteLater();

        // Reset pointer
        m_port = Q_NULLPTR;

        // Warn user (if serial port was valid)
        if (!name.isEmpty())
            emit connectionError (name);
    }

    // Update UI
    emit connectionChanged();
}

void SerialManager::configureLogFile() {
    // Close log file
    if (m_file.isOpen())
        m_file.close();

    // Serial device is invalid, abort
    if (!m_port) {
        m_file.setFileName ("");
        return;
    }

    // Serial device is not open, abort
    if (!m_port->isOpen()) {
        m_file.setFileName ("");
        return;
    }

    // Get file name and path
    QString format = QDateTime::currentDateTime().toString ("yyyy/MMM/dd/");
    QString fileName = QDateTime::currentDateTime().toString("HH-mm-ss") + ".log";
    QString path = QString ("%1/.%2/%3/%4").arg (QDir::homePath(),
                                                 qApp->applicationName(),
                                                 m_port->portName(),
                                                 format);

    // Generate file path if required
    QDir dir (path);
    if (!dir.exists())
        dir.mkpath (".");

    // Open file
    m_file.setFileName (dir.filePath (fileName));
    if (!m_file.open (QFile::WriteOnly))
        qWarning() << "Cannot open" << m_file.fileName() << "for writting";
    else
        m_file.close();
}

void SerialManager::refreshSerialDevices() {
    // Create list starting with invalid virtual device
    QStringList devices;
    devices.append (tr ("Select Port"));

    // Search for serail devices
    foreach (QSerialPortInfo port, QSerialPortInfo::availablePorts()) {
        if (port.isValid() && !port.description().isEmpty())
            devices.append (port.portName());
    }

    // If the obtained list is different from previous list, update UI
    if (devices != m_serialDevices) {
        m_serialDevices = devices;
        emit serialDevicesChanged();
    }

    // Call this function again in one second
    QTimer::singleShot (1000, this, &SerialManager::refreshSerialDevices);
}

QString SerialManager::sizeStr (const quint64 bytes) const {
    QString units;
    float len = bytes;

    if (len < 1024)
        units = " " + tr ("bytes");

    else if (len < pow (1024, 2)) {
        len /= 1024;
        units = " " + tr ("KB");
    }

    else {
        len /= pow (1024, 2);
        units = " " + tr ("MB");
    }

    return QString::number (floorf (len * 100 + 0.5) / 100) + units;
}
