#include "Charger.h"
#include "Charger_Model.h"

Charger::Charger(Charger_Model* model)
{
	this->__nb_ammo = model->Get_Nb_Ammo();
	this->__charger_model = model;
}

Charger::~Charger()
{
}

int	Charger::Get_Id()
{
	return (this->__id);
}

void	Charger::Set_Id(int id)
{
	this->__id = id;
}

int	Charger::Get_Nb_Ammo()
{
	return (this->__nb_ammo);
}

void	Charger::Set_Nb_Ammo(int nb_ammo)
{
	this->__nb_ammo = nb_ammo;
}

Charger_Model*	Charger::Get_Charger_Model()
{
	return (this->__charger_model);
}

void	Charger::Set_Charger_Model(Charger_Model* charger)
{
	this->__charger_model = charger;
}

