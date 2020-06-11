#ifndef alledge_animated_model_h
#define alledge_animated_model_h

extern "C" {
#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>
}
#include "alledge/Animated_model.h"
#include "alledge/shared_ptr.h"

namespace alledge_lua
{

#define ANIMATED_MODEL_STRING "animated_model"

class Animated_model_ud
{
public:
	Animated_model_ud(shared_ptr<Animated_model> w)
	{
		animated_model = w;
	}
	shared_ptr<Animated_model> animated_model;
};

int register_animated_model (lua_State* L);

shared_ptr<Animated_model> check_animated_model (lua_State *L, int index);
Animated_model_ud* check_animated_model_ud (lua_State *L, int index);
Animated_model_ud* push_animated_model (lua_State *L, shared_ptr<Animated_model> im);

}

#endif
