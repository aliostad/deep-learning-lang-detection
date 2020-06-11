/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (directui@nokia.com)
**
** This file is part of systemui.
**
** If you have questions regarding the use of this file, please contact
** Nokia at directui@nokia.com.
**
** This library is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation
** and appearing in the file LICENSE.LGPL included in the packaging
** of this file.
**
****************************************************************************/


#ifndef STATUSINDICATORMODEL_H_
#define STATUSINDICATORMODEL_H_

#include <MWidgetModel>
#include <QVariant>

class StatusIndicatorModel : public MWidgetModel
{
    Q_OBJECT
    M_MODEL(StatusIndicatorModel)
    M_MODEL_PROPERTY(QVariant, value, Value, true, QVariant())
    M_MODEL_PROPERTY(bool, animate, Animate, true, false)
    M_MODEL_PROPERTY(QString, stylePostfix, StylePostfix, true, QString())
};

class PhoneNetworkSignalStrengthStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(PhoneNetworkSignalStrengthStatusIndicatorModel)
};

class PhoneNetworkTypeStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(PhoneNetworkTypeStatusIndicatorModel)
};

class PhoneNetworkStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(PhoneNetworkStatusIndicatorModel)
};

class BatteryStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(BatteryStatusIndicatorModel)
};

class BatteryPercentageStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(BatteryPercentageStatusIndicatorModel)
};

class AlarmStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(AlarmStatusIndicatorModel)
};

class ShortDistanceNetworkStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(ShortDistanceNetworkStatusIndicatorModel)
};

class GPSStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(GPSStatusIndicatorModel)
};

class PresenceStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(PresenceStatusIndicatorModel)
};

class InputMethodStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(InputMethodStatusIndicatorModel)
};

class CallStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(CallStatusIndicatorModel)
};

class TetheringStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(TetheringStatusIndicatorModel)
};

class ProfileStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(ProfileStatusIndicatorModel)
};

class NotificationStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(NotificationStatusIndicatorModel)
};

class CallForwardingStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(CallForwardingStatusIndicatorModel)
};

class TransferStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(TransferStatusIndicatorModel)
};

class DLNAStatusIndicatorModel : public StatusIndicatorModel
{
    M_MODEL(DLNAStatusIndicatorModel)
};

#endif /* STATUSINDICATORMODEL_H_ */
