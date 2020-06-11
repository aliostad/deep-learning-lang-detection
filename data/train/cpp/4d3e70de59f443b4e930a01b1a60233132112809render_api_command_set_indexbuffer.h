
#ifndef dragonpoop_render_api_command_set_indexbuffer_h
#define dragonpoop_render_api_command_set_indexbuffer_h

#include "render_api_command.h"

namespace dragonpoop
{
    
    class render_api_indexbuffer_writelock;
    class render_api_indexbuffer_ref;
    class render_api_indexbuffer;
    
    class render_api_command_set_indexbuffer : public render_api_command
    {
        
    private:
        
        render_api_indexbuffer_ref *r;
        
    protected:
        
    public:
        
        //ctor
        render_api_command_set_indexbuffer( render_api_commandlist *l, render_api_indexbuffer *b );
        //ctor
        render_api_command_set_indexbuffer( render_api_commandlist *l, render_api_indexbuffer_ref *b );
        //ctor
        render_api_command_set_indexbuffer( render_api_commandlist *l, render_api_indexbuffer_writelock *b );
        //dtor
        virtual ~render_api_command_set_indexbuffer( void );
        //compile command
        virtual void compile( render_api_context_writelock *ctx );
        
    };
    
};

#endif