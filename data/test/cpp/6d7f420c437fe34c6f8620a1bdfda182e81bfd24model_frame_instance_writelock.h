
#ifndef dragonpoop_model_frame_instance_writelock_h
#define dragonpoop_model_frame_instance_writelock_h

#include "../model_component/model_component_writelock.h"

namespace dragonpoop
{

    class model_frame_instance;
    class model_frame_instance_ref;

    class model_frame_instance_writelock : public model_component_writelock
    {

    private:

        model_frame_instance *t;

    protected:

        //ctor
        model_frame_instance_writelock( model_frame_instance *t, dpmutex_writelock *l );
        //dtor
        virtual ~model_frame_instance_writelock( void );

    public:

        //return instance id
        dpid getInstanceId( void );
        //return frame id
        dpid getFrameId( void );

        friend class model_frame_instance;
    };
    
};

#endif