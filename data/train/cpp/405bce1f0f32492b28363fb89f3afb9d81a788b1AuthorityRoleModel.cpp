/*
 * File Name: AuthorityRoleModel.cpp
 * Written by: Cong Liao
 * Email: liaocong@seas.upenn.edu
 * Description:
 *
 */

#include "AuthorityRoleModel.h"
#include "Simulator.h"
#include "StringHelp.h"

// add model parameters

AuthorityRoleModel::AuthorityRoleModel(const QString& strModelName): RoleModel(strModelName)
{

}

AuthorityRoleModel::AuthorityRoleModel(const AuthorityRoleModel& copy): RoleModel(copy)
{

}

AuthorityRoleModel::~AuthorityRoleModel()
{

}

AuthorityRoleModel& AuthorityRoleModel::operator=(const AuthorityRoleModel& copy)
{
	RoleModel::operator=(copy);
	
	return *this;
}

int AuthorityRoleModel::Init(const std::map< QString, QString >& mapParams)
{
	if (RoleModel::Init(mapParams))
		return 1;
	
	return 0;
}

int AuthorityRoleModel::Save(map< QString, QString >& mapParams)
{
	if (RoleModel::Save(mapParams))
		return 1;
	
	return 0;
}

void AuthorityRoleModel::GetParams(map< QString, ModelParameter >& mapParams)
{
	RoleModel::GetParams(mapParams);
	
}
