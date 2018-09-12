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

#ifndef DATA_PARSER_H
#define DATA_PARSER_H

#include <QList>
#include <QVector>
#include <QObject>
#include <QVariant>
#include <QVector3D>

class DataParser : public QObject {
    Q_OBJECT

signals:
    void dataParsed();
    void packetError();
    void satelliteReset();
    void csvLoggingEnabledChanged();

public:
    DataParser();

    int teamId() const;
    int packetCount() const;
    quint64 missionTime() const;

    double altitude() const;
    double batteryVoltage() const;
    double relativeHumidity() const;
    double uvRadiationIndex() const;
    double internalTemperature() const;
    double externalTemperature() const;
    double atmosphericPressure() const;

    QDateTime gpsTime() const;
    double gpsVelocity() const;
    double gpsAltitude() const;
    double gpsLatitude() const;
    double gpsLongitude() const;
    int gpsSatelliteCount() const;

    QVector3D gyroscopeData() const;
    QVector3D accelerometerData() const;

    quint32 checksum() const;
    bool csvLoggingEnabled() const;

public slots:
    void enableCsvLogging(const bool enabled);

private slots:
    void parsePacket(const QByteArray &data);

private:
    void saveCsvData();

private:
    quint32 m_crc32;
    QVector<QVariant> m_data;
    bool m_csvLoggingEnabled;
};

#endif
