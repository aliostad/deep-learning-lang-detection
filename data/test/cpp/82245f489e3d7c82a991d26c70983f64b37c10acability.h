#pragma once

#include "../internal.h"

class Champion;

enum
{
	ACTIVE_ABILITY = 1
	, PASSIVE_ABILITY = 2
	, TOGGLE_ABILITY = 4
};

struct invoke_arg_t
{
	Keyboard::Key	key;
	Vector2i		pos;
};

typedef function<void(Champion *, invoke_arg_t)> invoke_fn_t;

struct Ability
{
	wstring						name;
	int							flag;
	invoke_fn_t					invoke;
	int							cooltime;
	int							range;
	bool						targeting;
	int							casttime;
	wstring						icon;
	Flag						uiflag;
};

extern smap<wstring, Ability*> ability_map;

//void LoadAbilities();
//void ReleaseAbilities();