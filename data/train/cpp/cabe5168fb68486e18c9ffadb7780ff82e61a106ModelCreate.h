#pragma once

#include <Util/Precision.h>
#include <Util/Status.h>
#include <Input/InputData.h>
#include <Model/ModelData.h>

namespace Model
{
    Status setupNodeData(Input::Data& input, Model::Data& model);
    Status setupElementData(Input::Data& input, Model::Data& model);
    Status setupMaterialData(Input::Data& input, Model::Data& model);
    Status setupDirichletBC(Input::Data& input, Model::Data& model);
    Status setupNeumannBC(Input::Data& input, Model::Data& model);
    Status setupControl(Input::Data& input, Model::Data& model);

    Status createNDS(Model::Data& model);   // Node DOF Set
    Status createNDM(Model::Data& model);   // Node DOF Map
    Status createEDM(Model::Data& model);   // Element DOF Map

    Status createBCDM(Model::Data& model);          // Boundary Condition DOF Map
    Status createAdjustedNDM(Model::Data& model);   // Node DOF Map adjusted for Dirichlet BC
    Status createAdjustedEDM(Model::Data& model);   // Element DOF Map adjusted for Dirichlet BC

}