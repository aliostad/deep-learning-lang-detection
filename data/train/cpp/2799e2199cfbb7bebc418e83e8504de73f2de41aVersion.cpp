#include "stdafx.h"

namespace filerepo
{

RepoVersion::RepoVersion( const RepoPath &path )
    : repo_path_(path)
{
}

int RepoVersion::Read()
{
    std::string version_str;
    if (ReadFileToString(repo_path_.GetVersionFilePath(), &version_str)) {
        return atoi(version_str.c_str());
    }
    return INVALID_VERSION;
}

bool RepoVersion::Create()
{
    char buf[8] = {0};
    _itoa_s(FILE_REPO_VERSION, buf, 10);
    return WriteStringToFile(repo_path_.GetVersionFilePath(), buf);
}

int RepoVersion::Current()
{
    return FILE_REPO_VERSION;
}

bool RepoVersion::Exist()
{
    return IsFileExist(repo_path_.GetVersionFilePath());
}

} // filerepo
