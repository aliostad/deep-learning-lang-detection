#include "SoundObject.h"


CSoundObject::CSoundObject(GLint model)
{
switch(model){
	case GAME_MODEL_TREE:
		{
			ModelTree *tree;
			tree = new ModelTree();

			delete tree;
		}
		break;
	case GAME_MODEL_SPAWN:
		{
			ModelSpawn *spawn;
			spawn = new ModelSpawn();

			delete spawn;
		}
		break;
	case GAME_MODEL_WALL:
		{
			ModelWall *wall;
			wall = new ModelWall();

			delete wall;
		}
		break;
	case GAME_MODEL_GOBLIN:
		{
			ModelGoblin *goblin;
			goblin = new ModelGoblin();

			delete goblin;
		}
		break;
	case GAME_MODEL_GROUND:
	default:
		break;
	}
}


CSoundObject::~CSoundObject(void)
{
}
