// ObjectDef.cpp
//
//////////////////////////////////////////////////////

#include "StdAfx.h"
#include "ObjectDef.h"

enum ENUM_LOCATOR_UNIT
{
	LOCATOR_UNIT_INVALID	= -1,
	LOCATOR_UNIT_CENTER,			// 身体中心
	LOCATOR_UNIT_HEAD,				// 头部
	LOCATOR_UNIT_HAND_L,			// 左手
	LOCATOR_UNIT_HAND_R,			// 右手
	LOCATOR_UNIT_WEAPON_L,			// 左武器
	LOCATOR_UNIT_WEAPON_R,			// 右武器
	LOCATOR_UNIT_FOOT_L,			// 左脚
	LOCATOR_UNIT_FOOT_R,			// 右脚
	LOCATOR_UNIT_FOOT_CENTER,		// 脚底中心
	LOCATOR_UNIT_CALVARIA,			// 头顶偏上
	LOCATOR_UNIT_HAND_CENTER,		// 两手中心

	LOCATOR_UNIT_NUMBERS
};

INT GetLocatorName( ENUM_LOCATOR eLocator, const char **paszOutLocatorName )
{
	static LPCSTR lpszLocatorInvalid = "脚下光圈点";
	static LPCSTR alpszLocatorName[LOCATOR_UNIT_NUMBERS] = {
			"身体受击点",		//LOCATOR_UNIT_CENTER,		// 身体中心
			"头顶状态点",		//LOCATOR_UNIT_HEAD,		// 头部
			"左武器绑定点",		//LOCATOR_UNIT_HAND_L,		// 左手
			"右武器绑定点",		//LOCATOR_UNIT_HAND_R,		// 右手
			"左武器绑定点",		//LOCATOR_UNIT_WEAPON_L,	// 左武器
			"右武器绑定点",		//LOCATOR_UNIT_WEAPON_R,	// 右武器
			"左足踩地点01",		//LOCATOR_UNIT_FOOT_L,		// 左脚
			"右足踩地点",		//LOCATOR_UNIT_FOOT_R,		// 右脚
			"脚下光圈点",		//LOCATOR_UNIT_FOOT_CENTER,	// 脚底中心
			"头顶状态点",		//LOCATOR_UNIT_CALVARIA,	// 头顶偏上
			//"Center",			//LOCATOR_UNIT_CENTER,		// 身体中心
			//"Head",			//LOCATOR_UNIT_HEAD,		// 头部
			//"Hand_L",			//LOCATOR_UNIT_HAND_L,		// 左手
			//"Hand_R",			//LOCATOR_UNIT_HAND_R,		// 右手
			//"Weapon_L",		//LOCATOR_UNIT_WEAPON_L,	// 左武器
			//"Weapon_R",		//LOCATOR_UNIT_WEAPON_R,	// 右武器
			//"Foot_L",			//LOCATOR_UNIT_FOOT_L,		// 左脚
			//"Foot_R",			//LOCATOR_UNIT_FOOT_R,		// 右脚
			//"Foot_Center",	//LOCATOR_UNIT_FOOT_CENTER,	// 脚底中心
			//"Calvaria",		//LOCATOR_UNIT_CALVARIA,	// 头顶偏上
	};

	INT nNumResult = 0;
	switch ( eLocator )
	{
	case LOCATOR_CENTER:		// 身体中心
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_CENTER];
		break;
	case LOCATOR_HEAD:			// 头部
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_HEAD];
		break;
	case LOCATOR_HAND_L:		// 左手
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_HAND_L];
		break;
	case LOCATOR_HAND_R:		// 右手
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_HAND_R];
		break;
	case LOCATOR_WEAPON_L:		// 左武器
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_WEAPON_L];
		break;
	case LOCATOR_WEAPON_R:		// 右武器
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_WEAPON_R];
		break;
	case LOCATOR_FOOT_L:		// 左脚
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_FOOT_L];
		break;
	case LOCATOR_FOOT_R:		// 右脚
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_FOOT_R];
		break;
	case LOCATOR_FOOT_CENTER:	// 脚底中心
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_FOOT_CENTER];
		break;
	case LOCATOR_CALVARIA:		// 头顶偏上
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_CALVARIA];
		break;
	case LOCATOR_HAND_L_AND_R:	// 左手和右手
		nNumResult = 2;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_HAND_L];
		paszOutLocatorName[1]	= alpszLocatorName[LOCATOR_UNIT_HAND_R];
		break;
	case LOCATOR_HAND_CENTER:	// 两手中心
		nNumResult = 1;
		paszOutLocatorName[0]	= alpszLocatorName[LOCATOR_UNIT_HAND_CENTER];
		break;
	default:
		nNumResult = 0;
		break;
	}
	return nNumResult;
}

const char *szIDSTRING_WEAPON			= ("武器");
const char *szIDSTRING_CAP				= ("帽子");
const char *szIDSTRING_ARMOUR			= ("衣服");
const char *szIDSTRING_CUFF				= ("护腕");
const char *szIDSTRING_BOOT				= ("靴子");
const char *szIDSTRING_NECKLACE			= ("项链");
const char *szIDSTRING_SASH				= ("腰饰");
const char *szIDSTRING_RING				= ("戒指");

const char *szIDSTRING_FACE_MESH		= ("FaceMesh");
const char *szIDSTRING_FACE_MAT			= ("FaceMat");

const char *szIDSTRING_HAIR_MESH		= ("HairMesh");
const char *szIDSTRING_HAIR_MAT			= ("HairMat");

const char *szIDSTRING_MAINBODY_MESH	= ("MainBodyMesh");
const char *szIDSTRING_MAINBODY_MAT		= ("MainBodyMat");

const char *szIDSTRING_FOOT_MESH		= ("FootMesh");
const char *szIDSTRING_FOOT_MAT			= ("FootMat");

const char *szIDSTRING_CAP_MESH			= ("CapMesh");
const char *szIDSTRING_CAP_MAT			= ("CapMat");

const char *szIDSTRING_ARM_MESH			= ("ArmMesh");
const char *szIDSTRING_ARM_MAT			= ("ArmMat");

//const char *szIDSTRING_CURRENT_ACTION	= ("CurrAction");

const char *szIDSTRING_CURRENT_LEFTWEAPON	= ("LeftWeaponObj");
const char *szIDSTRING_CURRENT_RIGHTWEAPON	= ("RightWeaponObj");

const char *szIDSTRING_WEAPON_MAT			= ("weaponMat");
