//
//  ModelNode.h
//  SapanaViewerLibrary
//
//  Created by Jan Meier on 29.12.13.
//  Copyright (c) 2013 Visualization and MultiMedia Lab, University of Zurich, Switzerland. All rights reserved.
//

#pragma once
#ifndef SapanaViewerLibrary_ModelNode_H_
#define SapanaViewerLibrary_ModelNode_H_

// Base class includes
#include "LeafNode.h"
// External includes
#include <memory>

// Project includes
namespace spvs{
    class ModelData;
}

//TODO: Implement and document
namespace spvs
{
class ModelNode : public LeafNode
{
public: 
    explicit ModelNode(std::shared_ptr<const ModelData> modelData);
    ~ModelNode();
    
    /**
     * Returns the model data associated to this model
     * @return ModelData this node is associated to.
     */
     std::shared_ptr<const ModelData> getModelData() const {return modelData_;}
    
    /**
     * Sets the model this ModelNode is associated to.
     * @param modeldata shared_ptr to the new ModelData
     */
    void setModelData(std::shared_ptr<const ModelData> modelData);
    
private:
  
     std::shared_ptr<const ModelData> modelData_;
};
}

#endif /* defined(SapanaViewerLibrary_ModelNode_H_ */
