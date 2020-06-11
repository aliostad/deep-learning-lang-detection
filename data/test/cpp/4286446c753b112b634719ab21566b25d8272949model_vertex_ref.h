
#ifndef dragonpoop_model_vertex_ref_h
#define dragonpoop_model_vertex_ref_h

#include "../model_component/model_component_ref.h"

namespace dragonpoop
{

    class model_vertex;

    class model_vertex_ref : public model_component_ref
    {

    private:

        model_vertex *t;

    protected:

        //ctor
        model_vertex_ref( model_vertex *p, std::shared_ptr<shared_obj_refkernal> *k );

    public:

        //dtor
        virtual ~model_vertex_ref( void );

        friend class model_vertex;
    };
    
};

#endif