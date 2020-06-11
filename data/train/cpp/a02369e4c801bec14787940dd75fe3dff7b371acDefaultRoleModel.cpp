/*
 * File Name: DefaultRoleModel.cpp
 * Written by: Cong Liao
 * Email: liaocong@seas.upenn.edu
 * Description:
 *
 */

#include "DefaultRoleModel.h"
#include "Simulator.h"
#include "StringHelp.h"

// add model paramters

DefaultRoleModel::DefaultRoleModel(const QString& strModelName): RoleModel(strModelName)
{

}

DefaultRoleModel::DefaultRoleModel(const DefaultRoleModel& copy): RoleModel(copy)
{

}

DefaultRoleModel::~DefaultRoleModel()
{

}

DefaultRoleModel& DefaultRoleModel::operator=(const DefaultRoleModel& copy)
{
	RoleModel::operator=(copy);
	
	return *this;
}

int DefaultRoleModel::Init(const std::map< QString, QString >& mapParams)
{
	if (RoleModel::Init(mapParams))
		return 1;
	
	return 0;
}

int DefaultRoleModel::Save(map< QString, QString >& mapParams)
{
	if (RoleModel::Save(mapParams))
		return 1;
	
	return 0;
}

void DefaultRoleModel::GetParams(map< QString, ModelParameter >& mapParams)
{
	RoleModel::GetParams(mapParams);
	
}
