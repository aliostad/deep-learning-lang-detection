#ifndef __VehicleModel_H__
#define __VehicleModel_H__

#include "ActorModel.h"
#include "CargoModel.h"
#include <vector>
#include <memory>

class VehicleModel;
typedef std::shared_ptr<VehicleModel> VehicleModelPtr;

class VehicleModel : public ActorModel
{
public:
    VehicleModel()
        : _maxCargoSize(0)
        , _price(0)
    {}

public:
    std::vector<CargoModel> _cargos;
    int _maxCargoSize;

    long long int _price;

    VehicleModelPtr Clone()
    {
        return VehicleModelPtr(new VehicleModel(*this));
    }
};

#endif
