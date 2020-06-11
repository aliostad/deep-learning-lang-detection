#pragma once

class quad_model;

#include "../controller.h"

class quad_model_controller : public controller 
{
public:
    quad_model_controller(void);
    ~quad_model_controller(void);

public:
    enum e_action_ids
    {
        e_increase_radius,
        e_decrease_radius,
    };

    virtual model* get_model() const override;
    virtual void set_model(quad_model* val) ;


    void increase_radius();
    void decrease_radius();

    virtual bool is_action_enabled( int action );

protected:
    quad_model* _model;
};

