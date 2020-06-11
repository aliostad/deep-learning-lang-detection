//
//  ModelNode.cpp
//  SapanaViewerLibrary
//
//  Created by Jan Meier on 29.12.13.
//  Copyright (c) 2013 Visualization and MultiMedia Lab, University of Zurich, Switzerland. All rights reserved.
//

// Class definition include
#include "ModelNode.h"

// External includes
#include "vmmlib/vmmlib.hpp"

// Project includes
#include "ModelData.h"
using namespace spvs;

ModelNode::ModelNode(std::shared_ptr<const ModelData> modelData)
: LeafNode(SceneNodeType::MODEL_NODE)
, modelData_(modelData)
{

}

ModelNode::~ModelNode()
{
    
}

void ModelNode::setModelData(std::shared_ptr<const ModelData> modelData)
{
  // TODO: Implement
  modelData_.reset();
}

