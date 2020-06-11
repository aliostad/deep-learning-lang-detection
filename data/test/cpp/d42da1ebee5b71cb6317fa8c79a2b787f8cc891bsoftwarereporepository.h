#ifndef SOFTWAREREPOREPOSITORY_H
#define SOFTWAREREPOREPOSITORY_H

#include <iostream>
#include <memory>
#include <vector>
#include <soci/soci.h>
#include "entity/softwarerepo.h"
using namespace soci;


class SoftwareRepoRepository
{
	soci::session& dataBase;
public:
	SoftwareRepoRepository(soci::session& dataBase);
	int insert(const SoftwareRepo& softwarerepo);
	SoftwareRepoPtr select(const SoftwareRepo& softwarerepo);
	SoftwareRepoList select(const string& where="");
	void update(const SoftwareRepo& softwarerepo);
	void update(const SoftwareRepo& oldObj, const SoftwareRepo& newObj);
	void remove(const SoftwareRepo& softwarerepo);
};

namespace soci
{
template<>
struct type_conversion<SoftwareRepo>
{
typedef values base_type;
	template<class T>	static void from_base(const T& v, const indicator& ind, SoftwareRepo & p)
	{
		if (v.get_indicator("SoftwareRepo_software_repo_id") != i_null){
			p.setSoftwareRepoId( v.template get<long long>("SoftwareRepo_software_repo_id" ) );
		}
		if (v.get_indicator("SoftwareRepo_sys_userid") != i_null){
			p.setSysUserid( v.template get<long long>("SoftwareRepo_sys_userid" ) );
		}
		if (v.get_indicator("SoftwareRepo_sys_groupid") != i_null){
			p.setSysGroupid( v.template get<long long>("SoftwareRepo_sys_groupid" ) );
		}
		if (v.get_indicator("SoftwareRepo_sys_perm_user") != i_null){
			p.setSysPermUser( v.template get<std::string>("SoftwareRepo_sys_perm_user" ) );
		}
		if (v.get_indicator("SoftwareRepo_sys_perm_group") != i_null){
			p.setSysPermGroup( v.template get<std::string>("SoftwareRepo_sys_perm_group" ) );
		}
		if (v.get_indicator("SoftwareRepo_sys_perm_other") != i_null){
			p.setSysPermOther( v.template get<std::string>("SoftwareRepo_sys_perm_other" ) );
		}
		if (v.get_indicator("SoftwareRepo_repo_name") != i_null){
			p.setRepoName( v.template get<std::string>("SoftwareRepo_repo_name" ) );
		}
		if (v.get_indicator("SoftwareRepo_repo_url") != i_null){
			p.setRepoUrl( v.template get<std::string>("SoftwareRepo_repo_url" ) );
		}
		if (v.get_indicator("SoftwareRepo_repo_username") != i_null){
			p.setRepoUsername( v.template get<std::string>("SoftwareRepo_repo_username" ) );
		}
		if (v.get_indicator("SoftwareRepo_repo_password") != i_null){
			p.setRepoPassword( v.template get<std::string>("SoftwareRepo_repo_password" ) );
		}
		if (v.get_indicator("SoftwareRepo_active") != i_null){
			p.setActive( v.template get<std::string>("SoftwareRepo_active" ) );
		}
	}
	static void to_base(const SoftwareRepo & p, values & v, indicator & ind)
	{
		v.set( "SoftwareRepo_software_repo_id", p.getSoftwareRepoId() );
		v.set( "SoftwareRepo_sys_userid", p.getSysUserid() );
		v.set( "SoftwareRepo_sys_groupid", p.getSysGroupid() );
		v.set( "SoftwareRepo_sys_perm_user", p.getSysPermUser() );
		v.set( "SoftwareRepo_sys_perm_group", p.getSysPermGroup() );
		v.set( "SoftwareRepo_sys_perm_other", p.getSysPermOther() );
		v.set( "SoftwareRepo_repo_name", p.getRepoName() );
		v.set( "SoftwareRepo_repo_url", p.getRepoUrl() );
		v.set( "SoftwareRepo_repo_username", p.getRepoUsername() );
		v.set( "SoftwareRepo_repo_password", p.getRepoPassword() );
		v.set( "SoftwareRepo_active", p.getActive() );
		ind = i_ok;
	}
};
}

#endif // SOFTWAREREPOREPOSITORY_H
