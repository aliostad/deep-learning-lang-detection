
#ifndef dragonpoop_model_joint_ref_h
#define dragonpoop_model_joint_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_joint;

    class model_joint_ref : public model_component_ref
    {

    private:

        model_joint *t;

    protected:

        //ctor
        model_joint_ref( model_joint *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_joint_ref( void );

        friend class model_joint;
    };
    
};

#endif