package freetype

/*
#cgo pkg-config: freetype2
#include <ft2build.h>
#include FT_FREETYPE_H
*/
import "C"

const (
	LoadDefault                  int = C.FT_LOAD_DEFAULT
	LoadNoScale                  int = C.FT_LOAD_NO_SCALE
	LoadNoHinting                int = C.FT_LOAD_NO_HINTING
	LoadRender                   int = C.FT_LOAD_RENDER
	LoadNoBitmap                 int = C.FT_LOAD_NO_BITMAP
	LoadVerticalLayout           int = C.FT_LOAD_VERTICAL_LAYOUT
	LoadForceAutohint            int = C.FT_LOAD_FORCE_AUTOHINT
	LoadCropBitmap               int = C.FT_LOAD_CROP_BITMAP
	LoadPedantic                 int = C.FT_LOAD_PEDANTIC
	LoadIgnoreGlobalAdvanceWidth int = C.FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH
	LoadNoRecurse                int = C.FT_LOAD_NO_RECURSE
	LoadIgnoreTransform          int = C.FT_LOAD_IGNORE_TRANSFORM
	LoadMonochrome               int = C.FT_LOAD_MONOCHROME
	LoadLinearDesign             int = C.FT_LOAD_LINEAR_DESIGN
	LoadNoAutohint               int = C.FT_LOAD_NO_AUTOHINT
	LoadColor                    int = C.FT_LOAD_COLOR
)
