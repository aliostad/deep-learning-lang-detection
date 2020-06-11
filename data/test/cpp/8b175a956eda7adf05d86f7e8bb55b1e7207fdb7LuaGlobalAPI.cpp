#include "LuaGlobalAPI.h"

LuaGlobalAPI::LuaGlobalAPI() {
  L = luaL_newstate();

  if (L == NULL) {
    cerr << "luaL_newstate returned NULL, memory allocation error!";
  }

  luaL_openlibs(L);
}

LuaGlobalAPI::~LuaGlobalAPI() {

}

void LuaGlobalAPI::attachAPI(LuaAPI* api) {
  cout << "attaching new API to lua state\n";
  // TODO: get definitions from the LuaAPI*, push into lua state
  // TODO: remember the definitions, so they can later be detached
}

void LuaGlobalAPI::detachAPI(LuaAPI* api) {
  // TODO: detach the definitions from attachAPI
  // do we need it?
}

void LuaGlobalAPI::runFile(string filename) {
  luaL_dofile(L, filename.c_str());
}
