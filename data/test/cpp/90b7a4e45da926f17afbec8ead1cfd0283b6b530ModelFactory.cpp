/*
 * ModelFactory.cpp
 *
 *  Created on: Aug 10, 2012
 *      Author: Vinayak Viswanathan
 */

#include <SkyDragonEngine/core/ModelType.hpp>
#include <SkyDragonEngine/core/ModelFactory.hpp>
#include <SkyDragonEngine/core/WaveFrontObjModelLoader.hpp>

namespace skydragonengine {

    ModelFactory::ModelFactory() {
        ModelType modelType = MODEL_TYPE_WAVEFRONT_OBJ;
        ModelLoader* objLoader = new WaveFrontObjModelLoader();

        _modelLoaders.insert(modelType, objLoader);
    }

    ModelFactory::~ModelFactory() {

    }

    SharedModelPtr ModelFactory::LoadModel(const Resource& source,
            ModelType modelType,
            const boost::optional<ModelLoaderParam>& modelLoaderParam) {
        boost::ptr_map<ModelType, ModelLoader>::iterator iter = _modelLoaders.find(modelType);
        ModelLoader* loader = iter->second;
        SharedModelPtr model = loader->LoadModel(source, modelLoaderParam);
        return model;
    }

} /* namespace skydragonengine */
