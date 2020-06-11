#include <map>
#include <iostream>

#include "unitmodel.h"

namespace game
{

    UnitModel::UnitModel(std::string modelName, std::string missileModelName, float maxHealth, float speed, std::string texture, bool hasAiFunction, bool hasPopFunction) : EntityModel(speed, texture, hasAiFunction, hasPopFunction)
    {
        m_maxHealth = maxHealth;
        m_missileModel = game::getMissileModel(missileModelName);
        registerUnitModel(modelName, this);
    }

    float UnitModel::getMaxHealth()
    {
        return m_maxHealth;
    }

    MissileModel* UnitModel::getMissileModel()
    {
        return m_missileModel;
    }

    std::map<std::string, UnitModel*> unitModels;

    void registerUnitModel(std::string modelName, UnitModel* model)
    {
        unitModels[modelName] = model;
    }

    UnitModel* getUnitModel(std::string modelName)
    {
        return unitModels[modelName];
    }

    void freeUnitModels()
    {
        for (std::map<std::string, UnitModel*>::iterator it = unitModels.begin(); it != unitModels.end(); it++)
            delete it->second;

        unitModels.clear();
    }

}
