
#ifndef dragonpoop_model_triangle_ref_h
#define dragonpoop_model_triangle_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_triangle;

    class model_triangle_ref : public model_component_ref
    {

    private:

        model_triangle *t;

    protected:

        //ctor
        model_triangle_ref( model_triangle *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_triangle_ref( void );

        friend class model_triangle;
    };
    
};

#endif