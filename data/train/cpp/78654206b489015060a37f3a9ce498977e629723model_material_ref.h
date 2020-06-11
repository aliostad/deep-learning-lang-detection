
#ifndef dragonpoop_model_material_ref_h
#define dragonpoop_model_material_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_material;

    class model_material_ref : public model_component_ref
    {

    private:

        model_material *t;

    protected:

        //ctor
        model_material_ref( model_material *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_material_ref( void );

        friend class model_material;
    };
    
};

#endif