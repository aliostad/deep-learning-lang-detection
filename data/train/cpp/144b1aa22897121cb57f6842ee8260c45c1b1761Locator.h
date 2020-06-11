#ifndef LOCATOR_H
#define LOCATOR_H

#include "GravitronSettings.h"
#include <QObject>
#include <QGuiApplication>

/**
 * The Locator helps to load the translation that is stored in the GravitronSettings.
 */
class Locator : public QObject {

    /** QT stuff*/
    Q_OBJECT

    private:
        /**
         * The settings.
         */
        GravitronSettings& settings;

        /**
         * The QGuiApplication to translate.
         */
        QGuiApplication& app;

        /**
         * The QTranslator object that sets the translation on the QUI.
         */
        QTranslator *translator;

    public:
        Locator(GravitronSettings& settings, QGuiApplication& app);
        ~Locator();

    public slots:
        void loadLanguage(const QString& source);
};

#endif // LOCATOR_H
