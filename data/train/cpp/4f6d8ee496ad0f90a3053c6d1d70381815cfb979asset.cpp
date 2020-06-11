#include "script/type/def.h"
#include "script/class_type.h"
#include "script/lua_bind.h"

#include "asset/asset_manager.h"
#include "asset/asset_locator.h"

#include "asset_support/texture_asset.h"
#include "re/texture.h"

namespace script {
    void def_asset() {
        class_<asset_collection>::type()
        .def("load_texture", LUA_BIND(&asset_collection::load<texture>))
        .def("contains", LUA_BIND(&asset_collection::contains))
        ;

        class_<asset_manager>::type()
        .derive<asset_collection>()
        ;
        
        class_<locator_mgr>::type()
        .def("from", LUA_BIND(&locator_mgr::from))
        .def("add_locator", LUA_BIND(&locator_mgr::add_locator))
        ;
    }
}
