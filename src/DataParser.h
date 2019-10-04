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
#include <QFile>
#include <QVector>
#include <QObject>
#include <QVariant>
#include <QVector3D>
#include <QDateTime>

#include "Constants.h"

class DataParser : public QObject {
    Q_OBJECT
    Q_PROPERTY(int teamId
               READ teamId
               NOTIFY dataParsed)
    Q_PROPERTY(int packetCount
               READ packetCount
               NOTIFY dataParsed)
    Q_PROPERTY(quint64 missionTime
               READ missionTime
               NOTIFY dataParsed)
    Q_PROPERTY(double altitude
               READ altitude
               NOTIFY dataParsed)
    Q_PROPERTY(double voltage
               READ batteryVoltage
               NOTIFY dataParsed)
    Q_PROPERTY(double intTemperature
               READ intTemperature
               NOTIFY dataParsed)
    Q_PROPERTY(double extTemperature
               READ extTemperature
               NOTIFY dataParsed)
    Q_PROPERTY(double atmosphericPressure
               READ atmosphericPressure
               NOTIFY dataParsed)
    Q_PROPERTY(QString gpsTime
               READ gpsTime
               NOTIFY dataParsed)
    Q_PROPERTY(double gpsAltitude
               READ gpsAltitude
               NOTIFY dataParsed)
    Q_PROPERTY(double gpsLongitude
               READ gpsLongitude
               NOTIFY dataParsed)
    Q_PROPERTY(double gpsLatitude
               READ gpsLatitude
               NOTIFY dataParsed)
    Q_PROPERTY(int gpsSatelliteCount
               READ gpsSatelliteCount
               NOTIFY dataParsed)
    Q_PROPERTY(QVector3D magnetometer
               READ magnetomerData
               NOTIFY dataParsed)
    Q_PROPERTY(QVector3D accelerometer
               READ accelerometerData
               NOTIFY dataParsed)
    Q_PROPERTY(bool parachuteStatus
               READ parachuteStatus
               NOTIFY dataParsed)
    Q_PROPERTY(double airQuality
               READ airQuality
               NOTIFY dataParsed)
    Q_PROPERTY(double carbonMonoxide
               READ carbonMonoxide
               NOTIFY dataParsed)
    Q_PROPERTY(quint32 checksum
               READ checksum
               NOTIFY dataParsed)
    Q_PROPERTY(bool csvLoggingEnabled
               READ csvLoggingEnabled
               WRITE enableCsvLogging
               NOTIFY csvLoggingEnabledChanged)
    Q_PROPERTY(int errorCount
               READ errorCount
               NOTIFY packetError)
    Q_PROPERTY(int resetCount
               READ resetCount
               NOTIFY satelliteReset)
    Q_PROPERTY(int successCount
               READ successCount
               NOTIFY dataParsed)

public:
    enum DataPosition {
        kHeader,
        kTeamID,
        kPacketCount,
        kAltitude,
        kAtmPressure,
        kBatteryVoltage,
        kIntTemperature,
        kExtTemperature,
        kAirQuality,
        kCarbonMonoxide,
        kGpsTime,
        kGpsLongitudeDeg,
        kGpsLongitudeMin,
        kGpsLatitudeDeg,
        kGpsLatitudeMin,
        kGpsAltitude,
        kGpsSatelliteCount,
        kAccelerometerX,
        kAccelerometerY,
        kAccelerometerZ,
        kMagnetometerX,
        kMagnetometerY,
        kMagnetometerZ,
        kMisionTime,
        kParachute,
        kChecksumCode
    };
    Q_ENUM(DataPosition);

signals:
    void dataParsed();
    void packetError();
    void satelliteReset();
    void csvLoggingEnabledChanged();

public:
    DataParser();
    ~DataParser();

    int resetCount() const;
    int errorCount() const;
    int successCount() const;

    int teamId() const;
    int packetCount() const;
    quint64 missionTime() const;

    double altitude() const;
    double airQuality() const;
    double carbonMonoxide() const;
    double intTemperature() const;
    double extTemperature() const;
    double batteryVoltage() const;
    double atmosphericPressure() const;

    bool parachuteStatus() const;

    QString gpsTime() const;
    double gpsAltitude() const;
    double gpsLatitude() const;
    double gpsLongitude() const;
    int gpsSatelliteCount() const;

    QVector3D magnetomerData() const;
    QVector3D accelerometerData() const;

    quint32 checksum() const;
    bool csvLoggingEnabled() const;

public slots:
    void resetData();
    void openCsvFile();
    void enableCsvLogging(const bool enabled);

private slots:
    void saveCsvData();
    void onPacketError();
    void onPacketParsed();
    void onSatelliteReset();
    void parsePacket(const QByteArray &data);

private:
    QFile m_csvFile;
    quint32 m_crc32;
    int m_resetCount;
    int m_errorCount;
    int m_successCount;
    QVector<QVariant> m_data;
    bool m_csvLoggingEnabled;
};

#endif
