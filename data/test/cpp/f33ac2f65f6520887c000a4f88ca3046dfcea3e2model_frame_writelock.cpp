
#include "model_frame_writelock.h"
#include "model_frame.h"

namespace dragonpoop
{

    //ctor
    model_frame_writelock::model_frame_writelock( model_frame *t, dpmutex_writelock *l ) : model_component_writelock( t, l )
    {
        this->t = t;
    }

    //dtor
    model_frame_writelock::~model_frame_writelock( void )
    {

    }

    //get name
    void model_frame_writelock::getName( std::string *s )
    {
        this->t->getName( s );
    }

    //set name
    void model_frame_writelock::setName( std::string *s )
    {
        this->t->setName( s );
    }

};
