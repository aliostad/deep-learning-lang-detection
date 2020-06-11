
#ifndef dragonpoop_model_frame_instance_readlock_h
#define dragonpoop_model_frame_instance_readlock_h

#include "../model_component/model_component_readlock.h"

namespace dragonpoop
{

    class model_frame_instance;
    class model_frame_instance_ref;

    class model_frame_instance_readlock : public model_component_readlock
    {

    private:

        model_frame_instance *t;

    protected:

        //ctor
        model_frame_instance_readlock( model_frame_instance *t, dpmutex_readlock *l );
        //dtor
        virtual ~model_frame_instance_readlock( void );

    public:

        //return instance id
        dpid getInstanceId( void );
        //return frame id
        dpid getFrameId( void );

        friend class model_frame_instance;
    };
    
};

#endif