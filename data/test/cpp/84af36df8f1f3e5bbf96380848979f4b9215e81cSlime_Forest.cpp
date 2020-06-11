#include "Slime_Forest.h"


Slime_Forest::Slime_Forest(Position pos) : Enemy(pos)
{
	m_pos = pos;
	m_life = 10;
	m_damage = 20;
	m_def = 1;
	m_dir = 'd';
	LoadAllTextures();
}


void Slime_Forest::LoadAllTextures()
{
	LoadGLTextures("left", "Slime_left_01.png");
	LoadGLTextures("left", "Slime_left_02.png");
	LoadGLTextures("left", "Slime_left_03.png");
	LoadGLTextures("left", "Slime_left_04.png");
	LoadGLTextures("left", "Slime_left_05.png");

	LoadGLTextures("right", "Slime_right_01.png");
	LoadGLTextures("right", "Slime_right_02.png");
	LoadGLTextures("right", "Slime_right_03.png");
	LoadGLTextures("right", "Slime_right_04.png");
	LoadGLTextures("right", "Slime_right_05.png");

	LoadGLTextures("up", "Slime_up_01.png");
	LoadGLTextures("up", "Slime_up_02.png");
	LoadGLTextures("up", "Slime_up_03.png");
	LoadGLTextures("up", "Slime_up_04.png");
	LoadGLTextures("up", "Slime_up_05.png");

	LoadGLTextures("down", "Slime_down_01.png");
	LoadGLTextures("down", "Slime_down_02.png");
	LoadGLTextures("down", "Slime_down_03.png");
	LoadGLTextures("down", "Slime_down_04.png");
	LoadGLTextures("down", "Slime_down_05.png");

	LoadGLTextures("death", "Slime_death_01.png");
	LoadGLTextures("death", "Slime_death_02.png");
	LoadGLTextures("death", "Slime_death_03.png");
	LoadGLTextures("death", "Slime_death_04.png");

	LoadGLTextures("freeze", "Slime_freeze_01.png");
	LoadGLTextures("freeze", "Slime_freeze_02.png");
	LoadGLTextures("freeze", "Slime_freeze_03.png");
	LoadGLTextures("freeze", "Slime_freeze_04.png");
	LoadGLTextures("freeze", "Slime_freeze_05.png");
	LoadGLTextures("freeze", "Slime_freeze_06.png");
	LoadGLTextures("freeze", "Slime_freeze_07.png");
	LoadGLTextures("freeze", "Slime_freeze_06.png");
	LoadGLTextures("freeze", "Slime_freeze_05.png");
	LoadGLTextures("freeze", "Slime_freeze_04.png");
	LoadGLTextures("freeze", "Slime_freeze_03.png");
	LoadGLTextures("freeze", "Slime_freeze_02.png");
	LoadGLTextures("freeze", "Slime_freeze_01.png");
	LoadGLTextures("freeze", "Slime_freeze_01.png");

}

Slime_Forest::~Slime_Forest()
{
}
