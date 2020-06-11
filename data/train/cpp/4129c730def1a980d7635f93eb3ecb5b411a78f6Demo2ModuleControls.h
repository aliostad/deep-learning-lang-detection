/*
 * Copyright (c) 2014-2015 Dave French <contact/dot/dave/dot/french3/at/googlemail/dot/com>
 *
 * This file is part of Involve - http://github.com/curlymorphic/involve
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program (see COPYING); if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 */


#ifndef DEMO2MODULECONTROLS_H
#define DEMO2MODULECONTROLS_H

#include <QObject>
#include "ModuleControls.h"
#include "Model.h"

class Demo2ModuleControls : public ModuleControls
{
	Q_OBJECT
public:

	explicit Demo2ModuleControls( QObject *parent = 0 );
	~Demo2ModuleControls();

	enum MixModes { MIXMODE_MIX, MIXMODE_RINGMOD, MIXMODE_COUNT };

	Model **oscAWaveShapeModels;
	Model oscASegmentCountModel;
	Model oscARetriggerModel;
	Model oscAGainModel;
	Model oscACourseDetuneMode;
	Model oscAFineDetuneMode;


	Model **oscBWaveShapeModels;
	Model oscBSegmentCountModel;
	Model oscBRetriggerModel;
	Model oscBGainModel;
	Model oscBCourseDetuneMode;
	Model oscBFineDetuneMode;

	Model **lfoWaveShapeModels;
	Model lfoSegmentCountModel;
	Model lfoRetriggerModel;

	Model mixModeModel;

	Model cutoffModel;
	Model resModel;
	Model filterStagesModel;

	Model attackModel;
	Model decayModel;
	Model sustainModel;
	Model releaseModel;

	Model lfoSpeedModel;
	Model lfoGainModel;
	Model lfoFilterModel;

	Model delayAmountModel;
	Model delayTimeModel;
	Model delayFeedbackModel;
};

#endif // DEMO2MODULECONTROLS_H
