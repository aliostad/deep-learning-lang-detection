#ifndef INCLUDED_ENGINE_MODELCOMPONENT_H
#define INCLUDED_ENGINE_MODELCOMPONENT_H

//====================================================================================================
// Filename:	ModelComponent.h
// Created by:	Tyler Staples
// Description: Class representing Transform Component.
//====================================================================================================

//====================================================================================================
// Includes
//====================================================================================================

#include "Component.h"
#include "Model.h"

//====================================================================================================
// Class Declarations
//====================================================================================================

class ModelComponent : public Component
{
public:
    ModelComponent();
    ~ModelComponent();

    void SetModel(const Model* model) { mModel = model; }

    //Model* GetModel() { return mModel; }
    const Model* GetModel() const { return mModel; }

private:
    // TODO: hold ref to model which is managed elsewhere
    const Model* mModel;
};

#endif // #ifndef INCLUDED_ENGINE_MODELCOMPONENT_H