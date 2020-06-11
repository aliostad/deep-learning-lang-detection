/*
 * ModelLoader.cpp
 *
 *  Created on: Aug 9, 2012
 *      Author: Vinayak Viswanathan
 */

#include <SkyDragonEngine/core/ModelLoader.hpp>

namespace skydragonengine {

    ModelLoader::ModelLoader() {

    }

    ModelLoader::~ModelLoader() {

    }

    SharedModelPtr ModelLoader::LoadModel(const Resource& resource, const boost::optional<ModelLoaderParam>& loaderParam) {
        SharedModelPtr model = doLoadModel(resource, loaderParam);

        if (model) {
            if (loaderParam) {
                if (loaderParam->GetScaleFactor()) {
                    model->Scale(*loaderParam->GetScaleFactor());
                }

                if (loaderParam->IsCalculateNormals()) {
                    model->RegenerateVertexNormals();
                }
            }

            model->UpdateBoundingVolume();
        }

        return model;
    }

} /* namespace skydragonengine */
