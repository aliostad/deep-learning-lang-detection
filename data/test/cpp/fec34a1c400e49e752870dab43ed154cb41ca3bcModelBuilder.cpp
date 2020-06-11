/*  \file   ModelBuilder.cpp
    \date   Saturday August 10, 2013
    \author Gregory Diamos <solusstultus@gmail.com>
    \brief  The source file for the ModelBuilder class.
*/

// Lucius Includes
#include <lucius/model/interface/ModelBuilder.h>
#include <lucius/model/interface/Model.h>
#include <lucius/model/interface/ModelSpecification.h>

#include <lucius/network/interface/NeuralNetwork.h>

#include <lucius/util/interface/memory.h>

namespace lucius
{

namespace model
{

static void initializeModelFromSpecification(Model* model, const std::string& specification)
{
    ModelSpecification modelSpecification;

    modelSpecification.parseSpecification(specification);

    modelSpecification.initializeModel(*model);
}

std::unique_ptr<Model> ModelBuilder::create(const std::string& specification)
{
    auto model = std::make_unique<Model>();

    initializeModelFromSpecification(model.get(), specification);

    return model;
}

}

}


