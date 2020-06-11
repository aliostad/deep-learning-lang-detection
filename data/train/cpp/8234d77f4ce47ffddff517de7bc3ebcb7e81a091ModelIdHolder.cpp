#include "ModelIdHolder.h"

ModelIdHolder::ModelIdHolder()
{
	this->m_modelIds[0] = ModelId("Char");
	this->m_modelIds[2] = ModelId("PoisonTurret", "color", "glowIntensity");
	this->m_modelIds[3] = ModelId("LightningTurret", "color", "glowIntensity");
	this->m_modelIds[4] = ModelId("DeathTurret", "color", "glowIntensity");
	this->m_modelIds[5] = ModelId("FrostGun", "color", "glowIntensity");
	this->m_modelIds[6] = ModelId("FrostBase");
	this->m_modelIds[7] = ModelId("CloudOfDarkness");
	this->m_modelIds[8] = ModelId("Pentagram");
	this->m_modelIds[9] = ModelId("redKnightPassiveAura");
	this->m_modelIds[10] = ModelId("wall");
	this->m_modelIds[11] = ModelId("Arrow");
	this->m_modelIds[12] = ModelId("Bench");
	this->m_modelIds[13] = ModelId("barrel");
	this->m_modelIds[14] = ModelId("box");
	this->m_modelIds[15] = ModelId("Church");
	this->m_modelIds[16] = ModelId("cross");
	this->m_modelIds[17] = ModelId("tree");
	this->m_modelIds[18] = ModelId("fence");
	this->m_modelIds[19] = ModelId("fencePillar");
	this->m_modelIds[20] = ModelId("Fountain");
	this->m_modelIds[21] = ModelId("gravestone");
	this->m_modelIds[22] = ModelId("lampPost");
	this->m_modelIds[23] = ModelId("CloudOfDarkness");
	this->m_modelIds[24] = ModelId("demonblade");
	this->m_modelIds[25] = ModelId("colum");
	this->m_modelIds[26] = ModelId("columSign");
	this->m_modelIds[27] = ModelId("treeMedium");
	this->m_modelIds[28] = ModelId("treeSmall");
	this->m_modelIds[29] = ModelId("gateBigHigh");
	this->m_modelIds[30] = ModelId("gateBigLow");
	this->m_modelIds[31] = ModelId("gateSmallHigh");
	this->m_modelIds[32] = ModelId("gateSmallLow");
	this->m_modelIds[33] = ModelId("cityHall");
	this->m_modelIds[34] = ModelId("asylum");
	this->m_modelIds[35] = ModelId("FountainAngel");

	
	this->m_modelIds[74] = ModelId("House05");
	this->m_modelIds[75] = ModelId("House00");
	this->m_modelIds[76] = ModelId("House01");
	this->m_modelIds[77] = ModelId("House02");
	this->m_modelIds[78] = ModelId("House03");
	this->m_modelIds[79] = ModelId("House04");

	this->m_modelIds[80] = ModelId("Imp", "color", "glowIntensity"); //Frost demon
	this->m_modelIds[81] = ModelId("Imp", "color1", "glowIntensity1"); //Imp
	this->m_modelIds[82] = ModelId("Imp", "color2", "glowIntensity2"); //Shade
	this->m_modelIds[83] = ModelId("Imp", "color3", "glowIntensity3"); //Spitting
	
	this->m_modelIds[84] = ModelId("Beast", "color", "glowIntensity"); //Soul Eater
	this->m_modelIds[85] = ModelId("Beast", "color1", "glowIntensity1"); //Brute 
	this->m_modelIds[86] = ModelId("Beast", "color2", "glowIntensity2"); //Hellfire
	this->m_modelIds[87] = ModelId("Beast", "color3", "glowIntensity3"); //Thunder
	this->m_modelIds[88] = ModelId("Imp","color5","glowIntensity4");
	this->m_modelIds[89] = ModelId("Char","color5","glowIntensity2","");	//boss

	this->m_modelIds[95] = ModelId("Char", "color", "", "DECLHatt"); //Officer
	this->m_modelIds[96] = ModelId("Char", "color1", "", "IronMan"); //Red Knight
	this->m_modelIds[97] = ModelId("Char", "color2", "", "GasMask"); //Engineer
	this->m_modelIds[98] = ModelId("Char", "color3", "", "Kubb");  //Doctor
	this->m_modelIds[99] = ModelId("Char", "color4", "", "TopHat"); //Mentalist

	this->m_modelIds[89].weapons[WEAPON_TYPE::MELEE] = WeaponSet("demonblade", "demonblade");
	this->m_modelIds[89].weapons[WEAPON_TYPE::RANGED] = WeaponSet("HexaGun", "lantern");
	this->m_modelIds[89].weapons[WEAPON_TYPE::AOE] = WeaponSet("demonblade", "");

	//Officer
	this->m_modelIds[95].weapons[WEAPON_TYPE::MELEE] = WeaponSet("OfficerRapier", "lantern");
	this->m_modelIds[95].weapons[WEAPON_TYPE::RANGED] = WeaponSet("HexaGun", "lantern");

	//Red Knight
	this->m_modelIds[96].weapons[WEAPON_TYPE::MELEE] = WeaponSet("Sword", "lantern");
	this->m_modelIds[96].weapons[WEAPON_TYPE::AOE] = WeaponSet("Mace", "");

	//Engineer
	this->m_modelIds[97].weapons[WEAPON_TYPE::MELEE] = WeaponSet("Wrench", "lantern");
	this->m_modelIds[97].weapons[WEAPON_TYPE::RANGED] = WeaponSet("Crossbow", "lantern");

	//Doctor
	this->m_modelIds[98].weapons[WEAPON_TYPE::MELEE] = WeaponSet("MeatClever", "lantern");
	this->m_modelIds[98].weapons[WEAPON_TYPE::RANGED] = WeaponSet("DoctorRevolver", "lantern");

	//Mentalist
	this->m_modelIds[99].weapons[WEAPON_TYPE::MELEE] = WeaponSet("MentalistRapier", "lantern");
	this->m_modelIds[99].weapons[WEAPON_TYPE::RANGED] = WeaponSet("MentalistRevolver", "lantern");
}

std::string ModelIdHolder::getHat(unsigned int id)
{
	if(id < ModelIdHolder::MAX_IDS)
	{
		return this->m_modelIds[id].hat;
	}
	else

	{
		return "";
	}
}

std::string ModelIdHolder::getRightHand(unsigned int id, unsigned short weaponType)
{
	if(id < ModelIdHolder::MAX_IDS && weaponType < 4)
	{
		return this->m_modelIds[id].weapons[weaponType].rightHand;
	}
	else
	{
		return "";
	}
}

std::string ModelIdHolder::getLeftHand(unsigned int id, unsigned short weaponType)
{
	if(id < ModelIdHolder::MAX_IDS && weaponType < 4)
	{
		return this->m_modelIds[id].weapons[weaponType].leftHand;
	}
	else
	{
		return "";
	}
}

std::string ModelIdHolder::getModel(unsigned int id)
{
	if(id < ModelIdHolder::MAX_IDS)
	{
		return this->m_modelIds[id].model;
	}
	else

	{
		return "";
	}
}

std::string ModelIdHolder::getTexture(int _index)const
{
	if(_index < ModelIdHolder::MAX_IDS)
	{
		return this->m_modelIds[_index].textures;
	}
	else

	{
		return "";
	}
}

std::string ModelIdHolder::getGlowmap(int _index)const
{
	if(_index < ModelIdHolder::MAX_IDS)
	{
		return this->m_modelIds[_index].glowMap;
	}
	else

	{
		return "";
	}
}