
#ifndef dragonpoop_render_api_command_set_shader_h
#define dragonpoop_render_api_command_set_shader_h

#include "render_api_command.h"

namespace dragonpoop
{
    
    class render_api_shader_writelock;
    class render_api_shader_ref;
    class render_api_shader;
    
    class render_api_command_set_shader : public render_api_command
    {
        
    private:
        
        render_api_shader_ref *r;
        
    protected:
        
    public:
        
        //ctor
        render_api_command_set_shader( render_api_commandlist *l, render_api_shader *b );
        //ctor
        render_api_command_set_shader( render_api_commandlist *l, render_api_shader_ref *b );
        //ctor
        render_api_command_set_shader( render_api_commandlist *l, render_api_shader_writelock *b );
        //dtor
        virtual ~render_api_command_set_shader( void );
        //compile command
        virtual void compile( render_api_context_writelock *ctx );
        
    };
    
};

#endif