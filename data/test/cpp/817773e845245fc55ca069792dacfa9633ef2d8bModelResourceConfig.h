/******************************************************************************/
#ifndef _MODEL_RESOURCE_CONFIG_H_
#define _MODEL_RESOURCE_CONFIG_H_
/******************************************************************************/

#include "EnginePreqs.h"
#include "IResourceManager.h"

/******************************************************************************/

namespace MG
{
	enum
	{
		MODEL_ID = 0,
		MODEL_NOTE,
		MODEL_GROUP_NAME,
		MODEL_NAME,
		MODEL_PRELOAD_TYPE,
		MODEL_USEAGE,
		MODEL_RESOURCE_PACK_ID,
		MODEL_PATH,
		MODEL_MESH_FILE,
		MODEL_MESH_FILE_HIGH_LEVEL,
		MODEL_ALLSIDE_BLOCK_MESH_FILE,
		MODEL_INSIDE_BLOCK_MESH_FILE,
		MODEL_OUTSIDE_BLOCK_MESH_FILE,
		MODEL_ROAD_MESH_FILE,
		MODEL_PASSAGE_MESH_FILE,
		MODEL_MATERIAL_FILE,
		MODEL_SKELETON_FILE,
		MODEL_ACTION_FILE,
		MODEL_REPLACE_ID,

		MODEL_ZOONX = 20,
		MODEL_ZOONY = 21,
		MODEL_ZOONZ = 22,
		MODEL_OFFSETY = 23,
		MODEL_PATHER_RADIUS = 24,
		
	};

	/******************************************************************************/
	//This is a interface class for reading CSV table of model resource .
	/******************************************************************************/
	class ModelResourceConfig
	{
	public:
		ModelResourceConfig(){};
		~ModelResourceConfig(){};
		SINGLETON_INSTANCE(ModelResourceConfig);

	public:

		//Load file for initializing model declaration maps of resource manager;
		Bool							load(CChar* filename);
		//UnLoad model declaration maps;
		void							unLoad();
	};
}

#endif