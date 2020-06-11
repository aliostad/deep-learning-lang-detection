#include "softwarereporepository.h"
#include "util.hpp"
SoftwareRepoRepository::SoftwareRepoRepository(soci::session& db) : dataBase(db)
{
}

SoftwareRepoPtr SoftwareRepoRepository::select(const SoftwareRepo& obj)
{
	soci::row row;
	SoftwareRepoPtr softwarerepo(new SoftwareRepo);
	dataBase << "SELECT  software_repo.software_repo_id as SoftwareRepo_software_repo_id, software_repo.sys_userid as SoftwareRepo_sys_userid, software_repo.sys_groupid as SoftwareRepo_sys_groupid, software_repo.sys_perm_user as SoftwareRepo_sys_perm_user, software_repo.sys_perm_group as SoftwareRepo_sys_perm_group, software_repo.sys_perm_other as SoftwareRepo_sys_perm_other, software_repo.repo_name as SoftwareRepo_repo_name, software_repo.repo_url as SoftwareRepo_repo_url, software_repo.repo_username as SoftwareRepo_repo_username, software_repo.repo_password as SoftwareRepo_repo_password, software_repo.active as SoftwareRepo_active"
	" FROM software_repo "
	"WHERE software_repo.software_repo_id = :SoftwareRepo_software_repo_id", into(row), use(obj);
	if(!dataBase.got_data())
		softwarerepo.reset();
	else
		type_conversion<SoftwareRepo>::from_base(row, i_ok, *softwarerepo);
	return softwarerepo;
}
SoftwareRepoList SoftwareRepoRepository::select(const string& where)
{
	soci::rowset<row> rs = 	dataBase.prepare << "SELECT  software_repo.software_repo_id as SoftwareRepo_software_repo_id, software_repo.sys_userid as SoftwareRepo_sys_userid, software_repo.sys_groupid as SoftwareRepo_sys_groupid, software_repo.sys_perm_user as SoftwareRepo_sys_perm_user, software_repo.sys_perm_group as SoftwareRepo_sys_perm_group, software_repo.sys_perm_other as SoftwareRepo_sys_perm_other, software_repo.repo_name as SoftwareRepo_repo_name, software_repo.repo_url as SoftwareRepo_repo_url, software_repo.repo_username as SoftwareRepo_repo_username, software_repo.repo_password as SoftwareRepo_repo_password, software_repo.active as SoftwareRepo_active "
	" FROM software_repo" 
	<< (where.size()?" WHERE "+where:"");
	SoftwareRepoList softwarerepoList;
	for(row& r: rs)
	{
		SoftwareRepoPtr softwarerepo(new SoftwareRepo);
		type_conversion<SoftwareRepo>::from_base(r, i_ok, *softwarerepo);
		softwarerepoList.push_back(softwarerepo);
	}
	return softwarerepoList;
}

int SoftwareRepoRepository::insert(const SoftwareRepo& softwarerepo)
{
	dataBase << "insert into software_repo(software_repo_id, sys_userid, sys_groupid, sys_perm_user, sys_perm_group, sys_perm_other, repo_name, repo_url, repo_username, repo_password, active)\
values(:SoftwareRepo_software_repo_id, :SoftwareRepo_sys_userid, :SoftwareRepo_sys_groupid, :SoftwareRepo_sys_perm_user, :SoftwareRepo_sys_perm_group, :SoftwareRepo_sys_perm_other, :SoftwareRepo_repo_name, :SoftwareRepo_repo_url, :SoftwareRepo_repo_username, :SoftwareRepo_repo_password, :SoftwareRepo_active)", use(softwarerepo);
	int id=0;
	dataBase << "SELECT LAST_INSERT_ID()", soci::into(id);
	return id;
}

void SoftwareRepoRepository::remove(const SoftwareRepo& softwarerepo)
{
	dataBase << "DELETE from software_repo WHERE software_repo_id=:SoftwareRepo_software_repo_id", use(softwarerepo);
}

void SoftwareRepoRepository::update(const SoftwareRepo& softwarerepo)
{
	dataBase << "update software_repo set software_repo_id=:SoftwareRepo_software_repo_id, sys_userid=:SoftwareRepo_sys_userid, sys_groupid=:SoftwareRepo_sys_groupid, sys_perm_user=:SoftwareRepo_sys_perm_user, sys_perm_group=:SoftwareRepo_sys_perm_group, sys_perm_other=:SoftwareRepo_sys_perm_other, repo_name=:SoftwareRepo_repo_name, repo_url=:SoftwareRepo_repo_url, repo_username=:SoftwareRepo_repo_username, repo_password=:SoftwareRepo_repo_password, active=:SoftwareRepo_active WHERE software_repo_id=:SoftwareRepo_software_repo_id", use(softwarerepo);
}

void SoftwareRepoRepository::update(const SoftwareRepo& oldObj, const SoftwareRepo& newObj)
{
	dataBase << "update software_repo set software_repo_id=:SoftwareRepo_software_repo_id, sys_userid=:SoftwareRepo_sys_userid, sys_groupid=:SoftwareRepo_sys_groupid, sys_perm_user=:SoftwareRepo_sys_perm_user, sys_perm_group=:SoftwareRepo_sys_perm_group, sys_perm_other=:SoftwareRepo_sys_perm_other, repo_name=:SoftwareRepo_repo_name, repo_url=:SoftwareRepo_repo_url, repo_username=:SoftwareRepo_repo_username, repo_password=:SoftwareRepo_repo_password, active=:SoftwareRepo_active WHERE software_repo_id='"<<oldObj.getSoftwareRepoId()<<"\'", use(newObj);
}

