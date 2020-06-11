
#ifndef dragonpoop_model_frame_readlock_h
#define dragonpoop_model_frame_readlock_h

#include "../model_component/model_component_readlock.h"
#include <string>

namespace dragonpoop
{
    class model_frame;
    class model_frame_ref;

    class model_frame_readlock : public model_component_readlock
    {

    private:

        model_frame *t;

    protected:

        //ctor
        model_frame_readlock( model_frame *t, dpmutex_readlock *l );
        //dtor
        virtual ~model_frame_readlock( void );

    public:

        //get name
        void getName( std::string *s );

        friend class model_frame;
    };
    
};

#endif