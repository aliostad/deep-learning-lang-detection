
#include "model_frame.h"
#include "model_frame_ref.h"
#include "model_frame_readlock.h"
#include "model_frame_writelock.h"

namespace dragonpoop
{

    //ctor
    model_frame::model_frame( model_writelock *ml, dpid id ) : model_component( ml, id, model_component_type_frame, 0 )
    {
    }

    //dtor
    model_frame::~model_frame( void )
    {
        model_component_writelock *l;
        shared_obj_guard g;

        l = (model_component_writelock *)g.writeLock( this );
        g.unlock();
    }

    //generate read lock
    shared_obj_readlock *model_frame::genReadLock( shared_obj *p, dpmutex_readlock *l )
    {
        return new model_frame_readlock( (model_frame *)p, l );
    }

    //generate write lock
    shared_obj_writelock *model_frame::genWriteLock( shared_obj *p, dpmutex_writelock *l )
    {
        return new model_frame_writelock( (model_frame *)p, l );
    }

    //generate ref
    shared_obj_ref *model_frame::genRef( shared_obj *p, std::shared_ptr<shared_obj_refkernal> *k )
    {
        return new model_frame_ref( (model_frame *)p, k );
    }

    //do background processing
    void model_frame::onRun( dpthread_lock *thd, gfx_writelock *g, model_writelock *m, model_component_writelock *l )
    {

    }

    //get name
    void model_frame::getName( std::string *s )
    {
        *s = this->sname;
    }

    //set name
    void model_frame::setName( std::string *s )
    {
        this->sname = *s;
    }
    
};
