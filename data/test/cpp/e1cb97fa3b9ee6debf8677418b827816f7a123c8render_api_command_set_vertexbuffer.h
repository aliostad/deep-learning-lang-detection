
#ifndef dragonpoop_render_api_command_set_vertexbuffer_h
#define dragonpoop_render_api_command_set_vertexbuffer_h

#include "render_api_command.h"

namespace dragonpoop
{
    
    class render_api_vertexbuffer_writelock;
    class render_api_vertexbuffer_ref;
    class render_api_vertexbuffer;
    
    class render_api_command_set_vertexbuffer : public render_api_command
    {
        
    private:
        
        render_api_vertexbuffer_ref *r;
        
    protected:
        
    public:
        
        //ctor
        render_api_command_set_vertexbuffer( render_api_commandlist *l, render_api_vertexbuffer *b );
        //ctor
        render_api_command_set_vertexbuffer( render_api_commandlist *l, render_api_vertexbuffer_ref *b );
        //ctor
        render_api_command_set_vertexbuffer( render_api_commandlist *l, render_api_vertexbuffer_writelock *b );
        //dtor
        virtual ~render_api_command_set_vertexbuffer( void );
        //compile command
        virtual void compile( render_api_context_writelock *ctx );
        
    };
    
};

#endif