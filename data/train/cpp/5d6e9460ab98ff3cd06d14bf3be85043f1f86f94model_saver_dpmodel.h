
#ifndef dragonpoop_model_saver_dpmodel_h
#define dragonpoop_model_saver_dpmodel_h

#include "../model_saver.h"

namespace dragonpoop
{
    
    class model_saver_dpmodel : public model_saver
    {
        
    private:
        
        model_ref *m;
        
    protected:
        
        //generate second state
        virtual model_saver_state *genState( dpbuffer *b );
        
    public:
        
        //ctor
        model_saver_dpmodel( core *c, model_ref *m, std::string *pname, std::string *fname );
        //dtor
        virtual ~model_saver_dpmodel( void );
        
    };
    
};

#endif