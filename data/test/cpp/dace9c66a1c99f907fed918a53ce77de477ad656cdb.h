#ifndef CDB_H
#define CDB_H

#include "shared/stdtypes.h"
#include <wchar.h>

bulk cdb_load(char* location);
void cdb_free();
void* cdb_handle();

int cdb_load_vdecl_parts();
int cdb_load_bdecl_parts();
int cdb_load_dbuf_decl();
int cdb_load_gpup();
int cdb_load_texture();
int cdb_load_draw_buffers();
int cdb_load_static_batches();
int cdb_load_2d_batch_groups();
int cdb_load_texture_sets();
int cdb_load_fonts();
int cdb_load_locales();
int cdb_load_gui_config();
int cdb_load_gui_skin(bulk id);
int cdb_load_display_obj_config();
int cdb_load_vm_vars();

wchar_t* cdb_get_localized_string(char* key, bulk locid);

#endif