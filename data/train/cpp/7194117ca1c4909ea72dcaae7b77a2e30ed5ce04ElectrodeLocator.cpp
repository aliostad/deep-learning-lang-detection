#include "ElectrodeLocator.h"
#include "Electrode.h"

ElectrodeLocator::ElectrodeLocator(Electrode &electrode)
    : blitz::Array<bool, 3>(!electrode.extractComponent(float(), 1, 3)) { // Definitely witchcraft
}

ElectrodeLocator::ElectrodeLocator(std::shared_ptr<Electrode> electrode)
    : blitz::Array<bool, 3>(!electrode->extractComponent(float(), 1, 3)) {
}

bool ElectrodeLocator::existsAt(int x, int y, int z) {
  return this->operator()(x, y, z);
}

bool ElectrodeLocator::existsAt(const tuple3Dint &r) {
  return this->operator()(std::get<0>(r), std::get<1>(r), std::get<2>(r));
}
