/*
 * Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
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

#ifndef _TRANSLATOR_H
#define _TRANSLATOR_H

#include <QObject>
#include <QTranslator>

#ifdef QT_QML_LIB
#include <QtQml>
#endif

class Translator : public QObject
{
    Q_OBJECT
    
#ifdef QT_QML_LIB
    Q_PROPERTY (int language
                READ language
                WRITE setLanguage
                NOTIFY languageChanged)
    Q_PROPERTY (QString dummy
                READ dummyString
                NOTIFY languageChanged)
    Q_PROPERTY (QStringList availableLanguages
                READ availableLanguages
                CONSTANT)
#endif
    
signals:
    void languageChanged();
    
public:
    explicit Translator();
    
    int language() const;
    int systemLanguage() const;
    QStringList availableLanguages() const;
    
    QString dummyString() const
    {
        return "";
    }
    
    static void DeclareQML()
    {
#ifdef QT_QML_LIB
        qmlRegisterType<Translator> ("Translator", 1, 0, "CTranslator");
#endif
    }
    
    public slots:
    void setLanguage (const int language);
    
private:
    int m_language;
    QTranslator m_translator;
};

#endif
