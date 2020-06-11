#ifndef alledge_static_model_h
#define alledge_static_model_h

extern "C" {
#include <lua5.1/lua.h>
#include <lua5.1/lualib.h>
#include <lua5.1/lauxlib.h>
}
#include "alledge/Static_model.h"
#include "alledge/shared_ptr.h"

namespace alledge_lua
{

#define STATIC_MODEL_STRING "static_model"

class Static_model_ud
{
public:
	Static_model_ud(shared_ptr<Static_model> w)
	{
		static_model = w;
	}
	shared_ptr<Static_model> static_model;
};

int register_static_model (lua_State* L);

shared_ptr<Static_model> check_static_model (lua_State *L, int index);
Static_model_ud* check_static_model_ud (lua_State *L, int index);
Static_model_ud* push_static_model (lua_State *L, shared_ptr<Static_model> im);

}

#endif
