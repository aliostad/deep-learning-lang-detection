#ifndef REPO_PATH_H
#define REPO_PATH_H

namespace filerepo
{

class RepoPath
{
public:
    RepoPath();
    RepoPath(const tstring &path);
    RepoPath(const RepoPath &rp);

    operator tstring() const;

    RepoPath &operator=(const RepoPath &rp);
    RepoPath &operator=(const tstring &path);

    tstring Data() const;

    tstring GetIndexFilePath();
    tstring GetTagsDirPath();
    tstring GetVersionFilePath();
    tstring GetManifestFilePath();
    tstring GetTaggedIndexFilePath(int n);

private:
    tstring repo_dir_;
};

} // namespace filerepo

#endif
