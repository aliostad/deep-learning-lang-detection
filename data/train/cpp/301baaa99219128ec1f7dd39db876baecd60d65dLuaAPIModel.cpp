#include "LuaAPIModel.h"

namespace LuaAPI {

	static int Model_LoadFromFile(lua_State* state) {

		Model::Model** NewUserdata = Utils::ToLuaUserdata<Model::Model*>(state, "Model");
		try {
			*NewUserdata = new Model::Model(luaL_checkstring(state, 1));
		} catch (std::exception e) {
			std::string ErrorMessage = std::string("Error loading model: ") + e.what();
			luaL_error(state, ErrorMessage.c_str());
		}
	
		return 1;
		
	}

	static int Model_Meta_gc(lua_State* state) {
		
		// TODO: This *might* be leaking memory.
		Model::Model* Self = Utils::FromLuaUserdata<Model::Model*>(state, 1, "Model");
		delete Self;

		return 0;

	}

	void OpenModel(lua_State* state) {
		
		// Register Model library.
		luaL_Reg ModelLibrary[] = {
			{ "LoadFromFile", Model_LoadFromFile },
			{ NULL, NULL }
		};
		luaL_newlib(state, ModelLibrary);
		lua_setglobal(state, "Model");

		// Register Model type.
		luaL_Reg ModelType[] = {
			{ "__gc", Model_Meta_gc },
			{ NULL, NULL }
		};
		Utils::RegisterLuaClass(state, "Model", ModelType);

	}

}