#include "ModelEvent.h"

ModelEvent::ModelEvent(int m, double p) {

    modelType = m;
    position = p;
}

ModelEvent::ModelEvent(ModelEvent& m) {
    
    modelType = m.modelType;
    position = m.position;
}

ModelEvent::~ModelEvent(void) {
    
}

bool ModelEvent::operator<(const ModelEvent& a) const {

    if ( position < a.position )
        return true;
    return false;
}

void ModelEvent::print(void) {

    std::cout << std::setw(4) << modelType << " " << std::fixed << std::setprecision(6) << position << std::endl;
}
