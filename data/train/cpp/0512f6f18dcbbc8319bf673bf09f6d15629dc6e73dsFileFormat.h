#pragma once
#include <string>
using namespace std;

class C3dsFileFormat
{
public:
	C3dsFileFormat() {}
protected:
	#pragma pack(2)
	typedef struct _chunk3ds
	{
		unsigned short	Flag;
		long			Size;
	} chunk3ds;
	#pragma pack()

	typedef struct _Transform3dsMatrix
	{
		float _11, _12, _13;
		float _21, _22, _23;
		float _31, _32, _33;
	} Transform3dsMatrix;

	typedef struct _Translate3dsMatrix
	{
		float _11, _12, _13;
	} Translate3dsMatrix;

	class ViewPortLayout
	{
	public:
		ViewPortLayout(unsigned short Style, short Active, short Unknow1, short Swap, 
					   short Unknow2, short Swap_prior, short Swap_view) : style(Style),
																		   active(Active),
																		   unknow1(Unknow1),
																		   swap(Swap),
																		   unknow2(Unknow2),
																		   swap_prior(Swap_prior),
																		   swap_view(Swap_view) {}
		unsigned short	style;
	    short			active;
		short			unknow1;
	    short			swap;
		short			unknow2;
	    short			swap_prior;
	    short			swap_view;
	};

	enum {CameraNameSize = 11};

	class ViewPortData
	{
	public:
		ViewPortData(short Flags, short Axis_lockout, short Win_x, short Win_y, short Win_w, short Win_h,
					 short Win_view, float Zoom, float Worldcenter_x, float Worldcenter_y, float Worldcenter_z,
					 float Horiz_ang, float Vert_ang, char *CameraName) : flags(Flags), axis_lockout(Axis_lockout),
																		  win_x(Win_x), win_y(Win_y),
																		  win_w(Win_w), win_h(Win_h),
																		  win_view(Win_view), zoom(Zoom),
																		  worldcenter_x(Worldcenter_x),
																		  worldcenter_y(Worldcenter_y),
																		  worldcenter_z(Worldcenter_z),
																		  horiz_ang(Horiz_ang), vert_ang(Vert_ang),
																		  camera_name(CameraName) {}
		short	flags, axis_lockout;
		short	win_x, win_y, win_w, win_h, win_view;
		float	zoom; 
		float	worldcenter_x, worldcenter_y, worldcenter_z;
		float	horiz_ang, vert_ang;
		string	camera_name;
	};

	enum {
		CHUNK_VERSION	= 0x0002,
	    CHUNK_RGBF      = 0x0010,
	    CHUNK_RGBB      = 0x0011,

		CHUNK_PERCENTW	= 0x0030,
		CHUNK_PERCENTF	= 0x0031,

	    CHUNK_PRJ       = 0xC23D,
	    CHUNK_MLI       = 0x3DAA,

	    CHUNK_MAIN      = 0x4D4D,
	        CHUNK_OBJMESH   = 0x3D3D,
				CHUNK_ONEUNIT	= 0x0100,
	            CHUNK_BKGCOLOR  = 0x1200,
	            CHUNK_AMBCOLOR  = 0x2100,
				CHUNK_DEFAULT_VIEW = 0x3000,
					CHUNK_VIEW_TOP = 0x3010,
					CHUNK_VIEW_BOTTOM = 0x3020,
					CHUNK_VIEW_LEFT = 0x3030,
					CHUNK_VIEW_RIGHT = 0x3040,
					CHUNK_VIEW_FRONT = 0x3050,
					CHUNK_VIEW_BACK = 0x3060,
					CHUNK_VIEW_USER = 0x3070,
					CHUNK_VIEW_CAMERA = 0x3080,

		    CHUNK_MESHV	=	0x3D3E,

	            CHUNK_OBJBLOCK  = 0x4000,
	                CHUNK_TRIMESH   = 0x4100,
	                    CHUNK_VERTLIST  = 0x4110,
	                    CHUNK_VERTFLAGS = 0x4111,
	                    CHUNK_FACELIST  = 0x4120,
	                    CHUNK_FACEMAT   = 0x4130,
	                    CHUNK_MAPLIST   = 0x4140,
	                    CHUNK_SMOOLIST  = 0x4150,
	                    CHUNK_TRMATRIX  = 0x4160,
	                    CHUNK_MESHCOLOR = 0x4165,
	                    CHUNK_TXTINFO   = 0x4170,
	                CHUNK_LIGHT     = 0x4600,
	                    CHUNK_SPOTLIGHT = 0x4610,
	                CHUNK_CAMERA    = 0x4700,
	                CHUNK_HIERARCHY = 0x4F00,

	        CHUNK_VIEWPORT_LAYOUT_OLD	= 0x7000,
				CHUNK_VIEWPORT_DATA_OLD	= 0x7010,
					CHUNK_VIEWPORT_SIZE = 0x7020,
						CHUNK_NETWORK_VIEW = 0X7030,

	        CHUNK_VIEWPORT_LAYOUT	= 0x7001,
				CHUNK_VIEWPORT_DATA	= 0x7011,
				CHUNK_VIEWPORT_DATA3 = 0x7012,

			CHUNK_MATERIAL  = 0xAFFF,
	            CHUNK_MATNAME   = 0xA000,
	            CHUNK_AMBIENT   = 0xA010,
	            CHUNK_DIFFUSE   = 0xA020,

	            CHUNK_SPECULAR  = 0xA030,
				CHUNK_SHINE		= 0xA040,
				CHUNK_SHINE_STR	= 0xA041,

				CHUNK_ALPHA		= 0xA050,
				CHUNK_ALPHAFALL	= 0xA052,
				CHUNK_ALPHA_BLUR= 0xA053,

				CHUNK_SELFLITE	= 0xA084,
				CHUNK_WIRETICK  = 0xA087,
			    CHUNK_INTRANC	= 0xA08A,

			    CHUNK_RENDERMODE= 0xA100,

	            CHUNK_TEXTURE   = 0xA200,
	            CHUNK_BUMPMAP   = 0xA230,
	            CHUNK_MAPFILE   = 0xA300,

				CHUNK_M_OPTIONS	= 0xA351,
				CHUNK_M_BLUR	= 0xA353,

				CHUNK_U_SCALE	= 0xA354,
				CHUNK_V_SCALE	= 0xA356,
				CHUNK_U_OFFSET	= 0xA358,
				CHUNK_V_OFFSET	= 0xA35A,
				CHUNK_M_ROTATE	= 0xA35C,

	        CHUNK_KEYFRAMER = 0xB000,
	            CHUNK_AMBIENTKEY    = 0xB001,
	            CHUNK_TRACKINFO = 0xB002,
	                CHUNK_TRACKOBJNAME  = 0xB010,
	                CHUNK_TRACKPIVOT    = 0xB013,
	                CHUNK_TRACKPOS      = 0xB020,
	                CHUNK_TRACKROTATE   = 0xB021,
	                CHUNK_TRACKSCALE    = 0xB022,
	                CHUNK_TRACKMORPH    = 0xB026,
	                CHUNK_TRACKHIDE     = 0xB029,
	                CHUNK_OBJNUMBER     = 0xB030,
	            CHUNK_TRACKCAMERA = 0xB003,
	                CHUNK_TRACKFOV  = 0xB023,
	                CHUNK_TRACKROLL = 0xB024,
	            CHUNK_TRACKCAMTGT = 0xB004,
	            CHUNK_TRACKLIGHT  = 0xB005,
	            CHUNK_TRACKLIGTGT = 0xB006,
	            CHUNK_TRACKSPOTL  = 0xB007,
	            CHUNK_FRAMES    = 0xB008
		};
};

