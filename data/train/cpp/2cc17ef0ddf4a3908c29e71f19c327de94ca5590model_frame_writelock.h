
#ifndef dragonpoop_model_frame_writelock_h
#define dragonpoop_model_frame_writelock_h

#include "../model_component/model_component_writelock.h"
#include <string>

namespace dragonpoop
{
    class model_frame;
    class model_frame_ref;

    class model_frame_writelock : public model_component_writelock
    {

    private:

        model_frame *t;

    protected:

        //ctor
        model_frame_writelock( model_frame *t, dpmutex_writelock *l );
        //dtor
        virtual ~model_frame_writelock( void );

    public:

        //get name
        void getName( std::string *s );
        //set name
        void setName( std::string *s );

        friend class model_frame;
    };
    
};

#endif