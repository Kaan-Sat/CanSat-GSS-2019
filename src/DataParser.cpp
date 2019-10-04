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

#include "crc32.h"
#include "Constants.h"
#include "DataParser.h"
#include "SerialManager.h"

#include <QMessageBox>
#include <QDesktopServices>

/**
 * Generates a vector of 0-value @c QVariant with @c x elements, where @c x
 * is the number of data/readings/status variables sent by the CanSat
 */
static QVector<QVariant> EmptyDataPacket() {
    QVector<QVariant> packet;
    const int packetItems = static_cast<int>(DataParser::kChecksumCode);

    for (int i = 0; i < packetItems; ++i)
        packet.append(QVariant(0));

    return packet;
}

/**
 * Class constructor function, initializes private members and configures
 * SIGNALS/SLOTS between the @c SerialManager class and data handling slots.
 */
DataParser::DataParser() :
    m_crc32(0),
    m_resetCount(0),
    m_errorCount(0),
    m_successCount(0),
    m_data(EmptyDataPacket()),
    m_csvLoggingEnabled (false)
{
    connect (SerialManager::getInstance(), &SerialManager::packetReceived,
             this, &DataParser::parsePacket);
    connect (this, &DataParser::dataParsed,
             this, &DataParser::saveCsvData);
    connect (this, &DataParser::dataParsed,
             this, &DataParser::onPacketParsed);
    connect (this, &DataParser::satelliteReset,
             this, &DataParser::onSatelliteReset);
    connect (this, &DataParser::packetError,
             this, &DataParser::onPacketError);
}

/**
 * Class destructor function, closes the CSV log file before quiting the app
 */
DataParser::~DataParser() {
    if (m_csvFile.isOpen())
        m_csvFile.close();
}

/**
 * @returns the number of satellites resets
 */
int DataParser::resetCount() const {
    return m_resetCount;
}

/**
 * @returns the number of packet reading errors
 */
int DataParser::errorCount() const {
    return m_errorCount;
}

/**
 * @returns the number of packets that were successfully read
 */
int DataParser::successCount() const {
    return m_successCount;
}

/**
 * @returns the team ID number
 */
int DataParser::teamId() const {
    return m_data.at(kTeamID).toInt();
}

/**
 * @returns the packet ID, this information can be latter used to know if
 *          one or more packets where lost during transmission
 */
int DataParser::packetCount() const {
    return m_data.at(kPacketCount).toInt();
}

/**
 * @returns the mission time in milliseconds
 */
quint64 DataParser::missionTime() const {
    return m_data.at(kMisionTime).toUInt();
}

/**
 * @returns the altitude of the CanSat in meters
 */
double DataParser::altitude() const {
    return RoundDbl(m_data.at(kAltitude).toDouble());
}

/**
 * @returns the battery voltage of the CanSat
 */
double DataParser::batteryVoltage() const {
    return RoundDbl(m_data.at(kBatteryVoltage).toDouble());
}

/**
 * @returns the air quality readings of the CanSat
 */
double DataParser::airQuality() const {
    return RoundDbl(m_data.at(kAirQuality).toDouble());
}

/**
 * @returns the carbon monoxide readings of the CanSat
 */
double DataParser::carbonMonoxide() const {
    return RoundDbl(m_data.at(kCarbonMonoxide).toDouble());
}

/**
 * @returns the internal temperature of the CanSat in Kelvins
 */
double DataParser::intTemperature() const {
    return RoundDbl(m_data.at(kIntTemperature).toDouble());
}

/**
 * @returns the external temperature of the CanSat in Kelvins
 */
double DataParser::extTemperature() const {
    return RoundDbl(m_data.at(kExtTemperature).toDouble());
}


/**
 * @returns the atmospheric pressure in millibars
 */
double DataParser::atmosphericPressure() const {
    return RoundDbl(m_data.at(kAtmPressure).toDouble());
}

/**
 * @returns the parachute deployment status
 */
bool DataParser::parachuteStatus() const {
    return m_data.at(kParachute).toInt() != 0;
}

/**
 * @returns the date/time received by the GPS module of the CanSat
 */
QString DataParser::gpsTime() const {
    QDateTime time;
    time.setTime_t (m_data.at(kGpsTime).toUInt());
    return time.toString("yyyy/MM/dd hh:mm:ss");
}

/**
 * @returns the calculated altitude based on GPS readings
 */
double DataParser::gpsAltitude() const {
    return RoundDbl(m_data.at(kGpsAltitude).toDouble());
}

/**
 * @returns the calculated latitude based on GPS readings
 */
double DataParser::gpsLatitude() const {
    return RoundDbl(m_data.at(kGpsLatitudeDeg).toDouble() +
                    m_data.at(kGpsLatitudeMin).toDouble() / 60.0);
}

/**
 * @returns the calculated longitude based on GPS readings
 */
double DataParser::gpsLongitude() const {
    return RoundDbl(m_data.at(kGpsLongitudeDeg).toDouble() +
                    m_data.at(kGpsLongitudeMin).toDouble() / 60.0);
}

/**
 * @returns the number of satellites detected by the GPS receiver
 */
int DataParser::gpsSatelliteCount() const {
    return m_data.at(kGpsSatelliteCount).toInt();
}

/**
 * @returns a vector with the (x,y,z) readings of the gyroscope
 *          sensor
 */
QVector3D DataParser::magnetomerData() const {
    QVector3D vector;
    vector.setX(m_data.at(kMagnetometerX).toFloat());
    vector.setY(m_data.at(kMagnetometerY).toFloat());
    vector.setZ(m_data.at(kMagnetometerZ).toFloat());
    return vector;
}

/**
 * @returns a vector with the (x,y,z) accelerometer readings
 */
QVector3D DataParser::accelerometerData() const {
    QVector3D vector;
    vector.setX(m_data.at(kAccelerometerX).toFloat());
    vector.setY(m_data.at(kAccelerometerY).toFloat());
    vector.setZ(m_data.at(kAccelerometerZ).toFloat());
    return vector;
}

/**
 * @returns the CRC32 checksum code of the last packet
 */
quint32 DataParser::checksum() const {
    if (ENABLE_CRC32)
        return m_data.at(kChecksumCode).toUInt();
    else
        return -1;
}

/**
 * @returns @c true if the class shall save all received data
 *          in a simple CSV table
 */
bool DataParser::csvLoggingEnabled() const {
    return m_csvLoggingEnabled;
}

/**
 * Resets all the internal variables to their initial state
 */
void DataParser::resetData() {
    m_crc32 = 0;
    m_errorCount = 0;
    m_resetCount = 0;
    m_successCount = 0;
    m_data = EmptyDataPacket();

    emit dataParsed();
    emit packetError();
    emit satelliteReset();
}

/**
 * Opens the CSV file using the system's default CSV editor app
 */
void DataParser::openCsvFile() {
    if (csvLoggingEnabled())
        QDesktopServices::openUrl(QUrl::fromLocalFile(m_csvFile.fileName()));
}

/**
 * @brief Enables or disables CSV logging
 *
 * If CSV logging is enabled, then all the packets that have been received
 * and interpreted (successfully) will be written in a simple CSV table
 * on the home directory of the user. This is useful for later analysis
 * of the mission data.
 */
void DataParser::enableCsvLogging(const bool enabled) {
    m_csvLoggingEnabled = enabled;

    if (!csvLoggingEnabled() && m_csvFile.isOpen())
        m_csvFile.close();

    emit csvLoggingEnabledChanged();
}

/**
 * @brief validates and decodes the given data @a packet and updates all
 *        internal variables that relate to the sensor readings, mission
 *        data and CanSat status
 */
void DataParser::parsePacket(const QByteArray& packet) {
    // Define 'global' function variables
    QStringList data;

    //--------------------------------------------------------------------------
    // Raw packet validation (so that we don't crash while reading data)
    //--------------------------------------------------------------------------
    if (ENABLE_PACKET_CHECK) {
        // Packet is empty, abort
        if (packet.isEmpty()) {
            emit packetError();
            return;
        }

        // Packet does not begin with header code, abort
        if (!packet.startsWith(HEADER_CODE)) {
            emit packetError();
            return;
        }

        // Packet does not end with secondary EOT code (primary EOT code was
        // used to separate incoming packets
        if (!packet.endsWith(EOT_SECONDARY.toLatin1())) {
            emit packetError();
            return;
        }

        // Ok, we can now begin analyzing the packet, start by making a copy
        // of the packet so that we can manipulate it
        QString copy = packet;

        // Remove secondary EOT character, we do not need it
        copy.chop(1);

        // Split packet data and verify that its length is valid
        data = copy.split(",");
        if (data.count() != EmptyDataPacket().count()) {
            emit packetError();
            return;
        }
    }

    //--------------------------------------------------------------------------
    // CRC-32 validation
    //--------------------------------------------------------------------------
    if (ENABLE_CRC32) {
        // Re-construct packet without CRC32 code
        QString rp;
        for (int i = 0; i < EmptyDataPacket().size(); ++i) {
            if (i != kChecksumCode) {
                rp.append(data.at(i));
                rp.append(DATA_SEPARATOR);
            }
        }

        // Calculate CRC-32 from reconstructed packet
        const size_t buffer_size = static_cast<size_t>(rp.size());
        const void* buffer = static_cast<const void*>(rp.toStdString().c_str());
        quint32 localCrc32 = CRC32(buffer, buffer_size);

        // Compare remote and local CRC-32 codes
        quint32 remoteCrc32 = data.at(kChecksumCode).toUInt();
        if (localCrc32 != remoteCrc32) {
            emit packetError();
            return;
        }
    }

    //--------------------------------------------------------------------------
    // Data handling
    //--------------------------------------------------------------------------
    {
        // Init. packet information vector
        QVector<QVariant> info = EmptyDataPacket();

        // Add UNIX/GPS offset in seconds, ignore leap seconds for now,
        // We do not depend on that...
        quint64 unixTime = data.at(kGpsTime).toULongLong() + 315964800;

        // Extract information to packet vector
        info.insert(kHeader,
                    QVariant(data.at(kHeader)));
        info.insert(kTeamID,
                    QVariant(data.at(kTeamID).toInt()));
        info.insert(kPacketCount,
                    QVariant(data.at(kPacketCount).toInt()));
        info.insert(kMisionTime,
                    QVariant(data.at(kMisionTime).toUInt()));
        info.insert(kAltitude,
                    QVariant(data.at(kAltitude).toDouble()));
        info.insert(kBatteryVoltage,
                    QVariant(data.at(kBatteryVoltage).toDouble()));
        info.insert(kIntTemperature,
                    QVariant(data.at(kIntTemperature).toDouble()));
        info.insert(kExtTemperature,
                    QVariant(data.at(kExtTemperature).toDouble()));
        info.insert(kAirQuality,
                    QVariant(data.at(kAirQuality).toDouble()));
        info.insert(kCarbonMonoxide,
                    QVariant(data.at(kCarbonMonoxide).toDouble()));
        info.insert(kAtmPressure,
                    QVariant(data.at(kAtmPressure).toDouble()));
        info.insert(kGpsTime, QVariant(unixTime));
        info.insert(kGpsAltitude,
                    QVariant(data.at(kGpsAltitude).toDouble()));
        info.insert(kGpsLatitudeMin,
                    QVariant(data.at(kGpsLatitudeMin).toDouble()));
        info.insert(kGpsLongitudeMin,
                    QVariant(data.at(kGpsLongitudeMin).toDouble()));
        info.insert(kGpsLatitudeDeg,
                    QVariant(data.at(kGpsLatitudeDeg).toDouble()));
        info.insert(kGpsLongitudeDeg,
                    QVariant(data.at(kGpsLongitudeDeg).toDouble()));
        info.insert(kGpsSatelliteCount,
                    QVariant(data.at(kGpsSatelliteCount)));
        info.insert(kAccelerometerX,
                    QVariant(data.at(kAccelerometerX).toDouble()));
        info.insert(kAccelerometerY,
                    QVariant(data.at(kAccelerometerY).toDouble()));
        info.insert(kAccelerometerZ,
                    QVariant(data.at(kAccelerometerZ).toDouble()));
        info.insert(kMagnetometerX,
                    QVariant(data.at(kMagnetometerX).toDouble()));
        info.insert(kMagnetometerY,
                    QVariant(data.at(kMagnetometerY).toDouble()));
        info.insert(kMagnetometerZ,
                    QVariant(data.at(kMagnetometerZ).toDouble()));
        info.insert(kParachute,
                    QVariant(data.at(kParachute)).toInt());
        if (ENABLE_CRC32)
            info.insert(kChecksumCode,
                        QVariant(data.at(kChecksumCode).toUInt()));

        // If current packet mision time is less than last packet, then a
        // a satellite reset ocurred
        if (missionTime() >= info.at(kMisionTime).toUInt())
            emit satelliteReset();

        // If received packet ID is smaller than the last packet ID, then a
        // satellite reset has ocurred.
        else if (packetCount() >= info.at(kPacketCount).toInt())
            emit satelliteReset();

        // Update current packet
        m_data = info;
        emit dataParsed();
    }
}

/**
 * Increments the number of packet reading errors
 */
void DataParser::onPacketError() {
    ++m_errorCount;
}

/**
 * Increments the number of packet reading successes
 */
void DataParser::onPacketParsed() {
    ++m_successCount;
}

/**
 * Increments the number of resets
 */
void DataParser::onSatelliteReset() {
    ++m_resetCount;
}

/**
 * @brief If the CSV logging feature is enabled, then this function
 *        shall save all the data extracted from the current packet
 *        to the CSV table.
 * @note If the CSV table file does not exist or is empty, then this
 *       function shall also write the header titles to the CSV file
 */
void DataParser::saveCsvData() {
    if (csvLoggingEnabled()) {
        // Open CSV file
        if (!m_csvFile.isOpen()) {
            // Get file name and path
            QString format = QDateTime::currentDateTime().toString("yyyy/MMM/dd/");
            QString fileName = QDateTime::currentDateTime().toString("HH-mm-ss") + ".csv";
            QString path = QString("%1/%2/%3/%4").arg(
                        QDir::homePath(),
                        qApp->applicationName(),
                        SerialManager::getInstance()->deviceName(),
                        format);

            // Generate file path if required
            QDir dir(path);
            if (!dir.exists())
                dir.mkpath(".");

            // Open file
            m_csvFile.setFileName(dir.filePath(fileName));
            if (!m_csvFile.open(QFile::WriteOnly)) {
                QMessageBox::critical(NULL,
                                      tr("CSV File Error"),
                                      tr("Cannot open CSV file for writing!"),
                                      QMessageBox::Ok);
                return;
            }

            // Add CSV data headers
            for (int i = 0; i < EmptyDataPacket().length(); ++i) {
                // Convert enum value to QString and write it to current cell
                m_csvFile.write(QMetaEnum::fromType<DataPosition>().valueToKey(i));

                // Go to the next column
                if (i < EmptyDataPacket().length() - 1)
                    m_csvFile.write(",");

                // Create a new row
                else
                    m_csvFile.write("\n");
            }

        }

        // Write current data to CSV file
        for (int i = 0; i < EmptyDataPacket().length(); ++i) {
            // Write UTF8 data to current cell
            m_csvFile.write(m_data.at(i).toByteArray());

            // Go to next column
            if (i < EmptyDataPacket().length() - 1)
                m_csvFile.write(",");

            // Create a new row
            else
                m_csvFile.write("\n");
        }
    }
}

