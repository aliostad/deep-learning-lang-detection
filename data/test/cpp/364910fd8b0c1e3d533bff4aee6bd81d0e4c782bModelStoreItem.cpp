/*
 * ModelStoreItem.cpp
 *
 *  Created on: Aug 11, 2012
 *      Author: Vinayak Viswanathan
 */

#include <SkyDragonEngine/core/ModelStoreItem.hpp>

namespace skydragonengine {

    ModelStoreItem::ModelStoreItem(
            const Resource& source,
            ModelType modelType):
                _modelSource(source),
                _modelType(modelType),
                _loaded(false) {
    }

    ModelStoreItem::ModelStoreItem(const Resource& source,
            ModelType modelType,
            const ModelLoaderParam& modelLoaderParam):
                        _modelSource(source),
                        _modelType(modelType),
                        _modelLoaderParam(modelLoaderParam),
                        _loaded(false) {

    }

    ModelStoreItem::~ModelStoreItem() {

    }

    const Resource& ModelStoreItem::GetSource() const {
        return _modelSource;
    }

    ModelType ModelStoreItem::GetModelType() const {
        return _modelType;
    }

    bool ModelStoreItem::IsLoaded() const {
        return _loaded;
    }

    void ModelStoreItem::SetLoadedModel(SharedModelPtr model) {
        _loadedModel = model;
        _loaded = true;
    }

    const boost::optional<ModelLoaderParam>& ModelStoreItem::GetModelLoaderParam() const {
        return _modelLoaderParam;
    }

    SharedModelPtr ModelStoreItem::GetLoadedModel() const {
        return _loadedModel;
    }

} /* namespace skydragonengine */
