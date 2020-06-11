#include "softwarerepo.h"

SoftwareRepo::SoftwareRepo(){
	init();
}
SoftwareRepo::SoftwareRepo(long long software_repo_id)
{
	init();
	this->software_repo_id = software_repo_id;
}

void SoftwareRepo::init()
{
}
long long SoftwareRepo::getSoftwareRepoId() const
{
	return software_repo_id;
}
void SoftwareRepo::setSoftwareRepoId(long long value)
{
	software_repo_id = value;
}
long long SoftwareRepo::getSysUserid() const
{
	return sys_userid;
}
void SoftwareRepo::setSysUserid(long long value)
{
	sys_userid = value;
}
long long SoftwareRepo::getSysGroupid() const
{
	return sys_groupid;
}
void SoftwareRepo::setSysGroupid(long long value)
{
	sys_groupid = value;
}
std::string SoftwareRepo::getSysPermUser() const
{
	return sys_perm_user;
}
void SoftwareRepo::setSysPermUser(std::string value)
{
	sys_perm_user = value;
}
std::string SoftwareRepo::getSysPermGroup() const
{
	return sys_perm_group;
}
void SoftwareRepo::setSysPermGroup(std::string value)
{
	sys_perm_group = value;
}
std::string SoftwareRepo::getSysPermOther() const
{
	return sys_perm_other;
}
void SoftwareRepo::setSysPermOther(std::string value)
{
	sys_perm_other = value;
}
std::string SoftwareRepo::getRepoName() const
{
	return repo_name;
}
void SoftwareRepo::setRepoName(std::string value)
{
	repo_name = value;
}
std::string SoftwareRepo::getRepoUrl() const
{
	return repo_url;
}
void SoftwareRepo::setRepoUrl(std::string value)
{
	repo_url = value;
}
std::string SoftwareRepo::getRepoUsername() const
{
	return repo_username;
}
void SoftwareRepo::setRepoUsername(std::string value)
{
	repo_username = value;
}
std::string SoftwareRepo::getRepoPassword() const
{
	return repo_password;
}
void SoftwareRepo::setRepoPassword(std::string value)
{
	repo_password = value;
}
std::string SoftwareRepo::getActive() const
{
	return active;
}
void SoftwareRepo::setActive(std::string value)
{
	active = value;
}

