#ifndef FILE_REPO_IMPL_H
#define FILE_REPO_IMPL_H

namespace filerepo
{

class FileRepoImpl : public FileRepo
{
public:
    FileRepoImpl(const RepoPath &repo_dir);
    ~FileRepoImpl();

    int Initialize();

    // Implement FileRepo
    virtual int AddFile(const tstring &file_path, const FileAttr &file_attr) OVERRIDE;
    virtual int AddDir(const FileAttr &file_attr) OVERRIDE;
    virtual int RemoveFile(const FileAttr &file_attr) OVERRIDE;
    virtual int CreateTag(const std::string &info) OVERRIDE;
    virtual int GetAllTags(std::vector<FileRepoTag> *tag_list) OVERRIDE;
    virtual int RemoveTag(const FileRepoTag &tag) OVERRIDE;
    //virtual FileEnumerator *CreateEnumerator() OVERRIDE;
    //virtual FileEnumerator *CreateEnumerator(const FileRepoTag &tag) OVERRIDE;
    virtual int GetVersion() OVERRIDE;
    virtual void Clear() OVERRIDE;

private:
    bool IsInited();

private:
    ObjectDb object_db_;
    RepoPath repo_dir_;
    QuickIndex *quick_index_;
    Json::Value root_;
    bool inited_;
    int version_;


    DISALLOW_COPY_AND_ASSIGN(FileRepoImpl);
};

} // namespace filerepo

#endif
