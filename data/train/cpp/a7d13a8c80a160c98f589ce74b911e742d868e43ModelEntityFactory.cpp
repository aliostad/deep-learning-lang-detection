/*
 * ModelEntityFactory.cpp
 *
 *  Created on: 15 nov. 2012
 *      Author: laplace
 */

#include "ModelEntityFactory.h"

namespace Model {

ModelEntityFactory* ModelEntityFactory::_instance = 0;

ModelEntityFactory::ModelEntityFactory() {
}

ModelEntityFactory::~ModelEntityFactory() {
}

ModelEntityFactory* ModelEntityFactory::instance() {
    if (_instance == 0) {
        _instance = new ModelEntityFactory();
    }
    return _instance;
}

void ModelEntityFactory::destroy() {
    if (_instance != 0) {
        delete _instance;
        _instance = 0;
    }
}

QObject* ModelEntityFactory::getEntity(const QString& name) const {
    return getObject(name);
}

} // namespace Model
