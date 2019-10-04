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

#include <QtQml>
#include <QQuickStyle>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "AppInfo.h"
#include "AppQuiter.h"
#include "DataParser.h"
#include "Translator.h"
#include "SerialManager.h"

/**
 * @brief Entry-point function of the application
 *
 * @param argc argument count
 * @param argv argument string array
 *
 * @returns the exit status of the @c qApp event loop
 */
int main(int argc, char** argv) {
    // Configure application flags
    QGuiApplication::setApplicationName(APP_NAME);
    QGuiApplication::setApplicationVersion(APP_VERSION);
    QGuiApplication::setOrganizationName(ORGANIZATION_NAME);
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    // Create application controller
    QGuiApplication app(argc, argv);

    // Create application modules
    DataParser parser;
    AppQuiter appQuiter;
    Translator translator;
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Universal");

    // Register QML modules
    Translator::DeclareQML();

    // Enable file logging for CSV and serial data
    parser.enableCsvLogging(true);
    SerialManager::getInstance()->enableFileLogging(true);

    // Configure QML engine context properties
    engine.rootContext()->setContextProperty("AppName", app.applicationName());
    engine.rootContext()->setContextProperty("AppCompany", app.organizationName());
    engine.rootContext()->setContextProperty("AppVersion", app.applicationVersion());
    engine.rootContext()->setContextProperty("CDataParser", &parser);
    engine.rootContext()->setContextProperty("CAppQuiter", &appQuiter);
    engine.rootContext()->setContextProperty ("Translator", &translator);
    engine.rootContext()->setContextProperty("CSerialManager", SerialManager::getInstance());
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    // Exit if QML interface contains errors
    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    // Enter application event loop
    return app.exec();
}
