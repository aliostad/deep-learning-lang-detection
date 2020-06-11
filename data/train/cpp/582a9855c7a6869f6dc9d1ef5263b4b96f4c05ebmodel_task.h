
#ifndef dragonpoop_model_task_h
#define dragonpoop_model_task_h

#include "../../core/dptask/dptask_owner.h"
#include "model.h"

namespace dragonpoop
{

    class model_ref;
    class model;

    class model_task : public dptask_owner
    {

    private:

        model_ref *g;

    protected:

    public:

        //ctor
        model_task( model *g );
        //dtor
        virtual ~model_task( void );
        //run by task
        virtual void run( dptask_writelock *tl, dpthread_lock *th );
        
    };
    
};

#endif