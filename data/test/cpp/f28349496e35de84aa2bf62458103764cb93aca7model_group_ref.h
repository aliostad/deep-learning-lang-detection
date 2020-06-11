
#ifndef dragonpoop_model_group_ref_h
#define dragonpoop_model_group_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_group;

    class model_group_ref : public model_component_ref
    {

    private:

        model_group *t;

    protected:

        //ctor
        model_group_ref( model_group *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_group_ref( void );

        friend class model_group;
    };
    
};

#endif