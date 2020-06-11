#ifndef TANAKA_MODEL_COMPONENT_H_
#define TANAKA_MODEL_COMPONENT_H_

#include "base_component.h"
#include "spatial_component.h"
#include "event_manager.h"
#include "assets\model_obj.h"
#include <glm/glm.hpp>

namespace Tanaka
{

class ModelComponent: public BaseComponent
{
public:
    typedef std::shared_ptr<ModelComponent> Ptr;
    ModelComponent();


    void draw();

    static
    Ptr Create();

    virtual
    std::string name() const;

    virtual
    void on_set_owner();

	void set_color(float r, float g, float b);

	void set_model(Model::Ptr model);

private:
    SpatialComponent* _spatial;
	Model::Ptr _model;
	glm::vec3 _color;

};

inline 
void ModelComponent::set_model(Model::Ptr model)
{
	_model = model;
}


}


#endif
