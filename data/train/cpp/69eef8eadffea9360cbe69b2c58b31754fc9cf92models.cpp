// This file os part of FVM
// Copyright (c) 2012 FVM Authors
// See LICENSE file for terms.

#include <atype.h>

#include "MeshMetricsCalculator.h"
#include "MeshMetricsCalculator_impl.h"

template class MeshMetricsCalculator<ATYPE>;


#include "ThermalModel.h"
#include "ThermalModel_impl.h"
template class ThermalModel<ATYPE>;

#include "VacancyModel.h"
#include "VacancyModel_impl.h"
template class VacancyModel<ATYPE>;

#include "FractureModel.h"
#include "FractureModel_impl.h"
template class FractureModel<ATYPE>;

#include "SpeciesModel.h"
#include "SpeciesModel_impl.h"
template class SpeciesModel<ATYPE>;

#include "BatteryModel.h"
#include "BatteryModel_impl.h"
template class BatteryModel<ATYPE>;

#ifndef USING_ATYPE_PC

#include "ElectricModel.h"
#include "ElectricModel_impl.h"
template class ElectricModel<ATYPE>;
#endif



#include "FlowModel.h"
#include "FlowModel_impl.h"

template class FlowModel<ATYPE>;

#include "IdealGasDensityModel.h"
#include "IdealGasDensityModel_impl.h"

template class IdealGasDensityModel<ATYPE>;



#ifndef USING_ATYPE_PC

#include "StructureModel.h"
#include "StructureModel_impl.h"

template class StructureModel<ATYPE>;
#include "PlateModel.h"
#include "PlateModel_impl.h"

template class PlateModel<ATYPE>;

#include "MovingMeshModel.h"


template class MovingMeshModel<ATYPE>;

#include "StructureDeformationModel.h"
template class StructureDeformationModel<ATYPE>;

#include "PlateDeformationModel.h"
template class PlateDeformationModel<ATYPE>;

#endif



