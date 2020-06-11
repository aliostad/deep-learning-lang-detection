#include "stdafx.h"

namespace filerepo
{


RepoPath::RepoPath( const tstring &path )
    : repo_dir_(path)
{
}

RepoPath::RepoPath( const RepoPath &rp )
{
    *this = rp;
}

RepoPath::RepoPath()
{

}

tstring RepoPath::GetIndexFilePath()
{
    return AppendPath(repo_dir_, _T("index"));
}

tstring RepoPath::GetTagsDirPath()
{
    return AppendPath(repo_dir_, _T("tags\\"));
}

tstring RepoPath::GetVersionFilePath()
{
    return AppendPath(repo_dir_, _T("version"));
}

tstring RepoPath::GetManifestFilePath()
{
    return AppendPath(repo_dir_, _T("manifest"));
}

tstring RepoPath::GetTaggedIndexFilePath( int n )
{
    char buf[8] = {0};
    _itoa_s(n, buf, 10);
    std::string index = "index_";
    index += buf;
    tstring windex = utf8_to_16(index.c_str());
    return AppendPath(GetTagsDirPath(), windex);
}

RepoPath &RepoPath::operator=( const tstring &path )
{
    repo_dir_ = path;
    return *this;
}

RepoPath &RepoPath::operator=( const RepoPath &rp )
{
    repo_dir_ = rp.repo_dir_;
    return *this;
}

tstring RepoPath::Data() const
{
    return repo_dir_;
}

RepoPath::operator tstring() const
{
    return repo_dir_;
}

}
