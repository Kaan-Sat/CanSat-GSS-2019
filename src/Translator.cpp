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

#include <QLocale>
#include <QSettings>

#include "Translator.h"

Translator::Translator() : m_language (0)
{
    QSettings settings (qApp->organizationName(), qApp->applicationName());
    setLanguage (settings.value ("language", systemLanguage()).toInt());
}

int Translator::language() const
{
    return m_language;
}

int Translator::systemLanguage() const
{
    int lang = 0;
    
    switch (QLocale::system().language()) {
        case QLocale::English:
            lang = 0;
            break;
        case QLocale::Spanish:
            lang = 1;
            break;
        default:
            lang = 0;
            break;
    }
    
    return lang;
}

QStringList Translator::availableLanguages() const
{
    return QStringList {
        "English",
        "Español"
    };
}

void Translator::setLanguage (const int language)
{
    /* Get translation file base name */
    QString file;
    QLocale locale;
    switch (language) {
        case 0:
            file = "en";
            locale = QLocale (QLocale::English);
            break;
        case 1:
            file = "es";
            locale = QLocale (QLocale::Spanish);
            break;
        default:
            file = "en";
            locale = QLocale (QLocale::English);
            break;
    }
    
    /* Load translation file */
    qApp->removeTranslator (&m_translator);
    m_translator.load (locale, ":/translations/" + file + ".qm");
    qApp->installTranslator (&m_translator);
    
    /* Save settings */
    QSettings settings (qApp->organizationName(), qApp->applicationName());
    settings.setValue ("language", language);
    
    /* Update internal variables & notify application */
    m_language = language;
    emit languageChanged();
}
