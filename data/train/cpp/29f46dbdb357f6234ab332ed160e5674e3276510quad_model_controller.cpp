#include "stdafx.h"
#include "quad_model_controller.h"

#include <core/model/quad_model.h>

quad_model_controller::quad_model_controller(void)
{
}


quad_model_controller::~quad_model_controller(void)
{
}

model* quad_model_controller::get_model() const
{
    return _model;
}

void quad_model_controller::set_model( quad_model* val )
{
    _model = val;
}

void quad_model_controller::increase_radius()
{
    if( !is_action_enabled(e_increase_radius) )
        return ; 

    _model->set_radius(_model->get_radius() + 0.1);
}

void quad_model_controller::decrease_radius()
{
    if( !is_action_enabled(e_decrease_radius) )
        return ; 

    _model->set_radius(_model->get_radius() - 0.1);
}

bool quad_model_controller::is_action_enabled( int action )
{
    double current_radius = _model->get_radius();

    switch( action )
    {
    case quad_model_controller::e_increase_radius:
        return current_radius < 1.2;
        break;
    case quad_model_controller::e_decrease_radius:
        return current_radius > 0.4;
        break;
    }

    return false;
}
