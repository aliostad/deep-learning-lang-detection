#pragma once

#include "Common/List.h"

#include "Models/AccelerationModel.h"
#include "Models/CalculatedGearModel.h"
#include "Models/InjectorModel.h"
#include "Models/ParkDistanceModel.h"
#include "Models/PitchModel.h"
#include "Models/RepresentableModel.h"
#include "Models/RollModel.h"
#include "Models/RPMModel.h"
#include "Models/SpeedModel.h"
#include "Models/TirePressureModel.h"
#include "Models/TripComputerModel.h"
#include "Models/VoltageModel.h"
#include "Models/WheelTickModel.h"

namespace PeripheralLayer
{
	class Peripherals;
}

namespace ApplicationLayer
{
	class ModelCollection
	{
	public:
		ModelCollection(PeripheralLayer::Peripherals& peripherals);

		const Models::RepresentableModel& GetSpeedModel() const;
		const Models::RepresentableModel& GetRPMModel() const;
		const Models::RepresentableModel& GetGearModel() const;

		const Models::TripComputerModel& GetTripComputerModel() const;
		const Models::RepresentableModel& GetParkDistanceModel() const;

		const Models::TirePressureModel& GetTirePressureModel() const;

		const Models::RepresentableModel& GetBatteryVoltageModel() const;

		const Models::Model& GetXAccelerationModel() const;
		const Models::Model& GetYAccelerationModel() const;
		const Models::Model& GetZAccelerationModel() const;

		const Models::RepresentableModel& GetPitchModel() const;
		const Models::RepresentableModel& GetRollModel() const;

		Common::List<Models::Model>& GetModels();

	private:
		Models::WheelTickModel m_WheelTickModel;
		Models::InjectorModel m_InjectorModel;
		Models::SpeedModel m_SpeedModel;
		Models::RPMModel m_RPMModel;

		Models::CalculatedGearModel m_GearModel;

		Models::TripComputerModel m_TripComputerModel;

		Models::ParkDistanceModel m_ParkDistanceModel;

		Models::TirePressureModel m_TirePressureModel;

		Models::VoltageModel m_BatteryVoltageModel;

		Models::AccelerationModel m_XAccelerationModel;
		Models::AccelerationModel m_YAccelerationModel;
		Models::AccelerationModel m_ZAccelerationModel;

		Models::PitchModel m_PitchModel;
		Models::RollModel m_RollModel;

		Common::List<Models::Model> m_ModelList;
	};
}
