// Copyright 2015 A.Bekkine

#include <stdio.h>

#include "AlphaModel.h"

AlphaModel::AlphaModel() {
    // TODO(abekkine) : CTOR
    puts("AlphaModel::AlphaModel()");
    Setup();
}

AlphaModel::~AlphaModel() {
    // TODO(abekkine) : DTOR
    puts("AlphaModel::~AlphaModel()");
    Cleanup();
}

void AlphaModel::Initialize() {
    // TODO(abekkine) : Initialization
    puts("AlphaModel::Initialize()");
    SetupScheduling();
}

void AlphaModel::ModelStep() {
    // TODO(abekkine) : Step function
    puts("AlphaModel::ModelStep()");
}

void AlphaModel::Setup() {
    // TODO(abekkine) : setup
    puts("AlphaModel::Setup()");
}

void AlphaModel::Cleanup() {
    // TODO(abekkine) : clean up
    puts("AlphaModel::Cleanup()");
}


