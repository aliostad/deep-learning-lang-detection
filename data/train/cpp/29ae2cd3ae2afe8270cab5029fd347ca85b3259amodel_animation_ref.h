
#ifndef dragonpoop_model_animation_ref_h
#define dragonpoop_model_animation_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_animation;

    class model_animation_ref : public model_component_ref
    {

    private:

        model_animation *t;

    protected:

        //ctor
        model_animation_ref( model_animation *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_animation_ref( void );

        friend class model_animation;
    };
    
};

#endif