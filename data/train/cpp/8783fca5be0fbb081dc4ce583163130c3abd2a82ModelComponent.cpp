/*
 * ModelConfiguration.cpp
 *
 *  Created on: Aug 3, 2012
 *      Author: Vinayak Viswanathan
 */

#include <SkyDragonEngine/core/ModelComponent.hpp>

namespace skydragonengine {

    ModelComponent::ModelComponent() {


    }

    ModelComponent::~ModelComponent() {

    }

    void ModelComponent::SetModelName(const std::string& modelName) {
        _modelName = modelName;
    }

    const std::string& ModelComponent::GetModelName() const {
        return _modelName;
    }

    void ModelComponent::AddTextureName(const std::string& textureName) {
        _textureNames.push_back(textureName);
    }

    const std::list<std::string>& ModelComponent::GetTextureNames() const {
        return _textureNames;
    }

    void ModelComponent::SetMaterial(const Material& material) {
        _material = material;
    }

    const boost::optional<Material>& ModelComponent::GetMaterial() const {
        return _material;
    }

} /* namespace skydragonengine */
