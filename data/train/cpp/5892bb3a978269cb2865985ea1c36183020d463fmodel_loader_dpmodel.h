
#ifndef dragonpoop_model_loader_dpmodel_h
#define dragonpoop_model_loader_dpmodel_h

#include "../model_loader.h"

namespace dragonpoop
{
    
    class model_loader_dpmodel : public model_loader
    {
        
    private:
        
        model_ref *m;
        
    protected:
        
        //generate second state
        virtual model_loader_state *genState( dpbuffer *b );
        
    public:
        
        //ctor
        model_loader_dpmodel( core *c, model_ref *m, std::string *pname, std::string *fname );
        //dtor
        virtual ~model_loader_dpmodel( void );
        
    };
    
};

#endif