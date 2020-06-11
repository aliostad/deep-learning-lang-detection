#ifndef FILE_REPO_H
#define FILE_REPO_H

#include "TypeDefines.h"

namespace filerepo
{

// Backup steps:
//
// std::vector<FileAttr> file_list_need_to_add = ...;
// std::vector<FileAttr> file_list_need_to_remove;
//
// FileRepo *repo = FileRepo::Create(_T("path to repo"));
// FileEnumerator *enumer = FileEnumerator::Create();
// while (!enumer.IsEnd()) {
//     FileAttr attr = enumer.GetFileAttr();
//     if (attr in file_list_need_to_backup) {
//         file_list_need_to_add.erase(attr); // already add
//     }
//     else {
//         file_list_need_to_remove.push_back(attr);
//     }
// }
// for (size_t i = 0; i < file_list_need_to_add.size(); i++) {
//     if (file_list_need_to_add.at(i).is_dir) {
//         repo.AddFile(path_on_local, file_list_need_to_add.at(i));
//     }
//     else {
//         repo.AddDir(path_on_local, file_list_need_to_add.at(i));
//     }
// }
// for (size_t i = 0; i < file_list_need_to_remove.size(); i++) {
//     repo.RemoveFile(file_list_need_to_remove.at(i));
// }
// repo.CreateTag("");
// repo.Clear();
//
/////////////////////////////////////////////////////////////////////
//
// Restore steps:
//
// FileRepo *repo = FileRepo::Create(_T("path to repo"));
// std::vector<FileRepoTag> tags;
// repo.GetAllTags(&tags);
// FileEnumerator *enumer = FileEnumerator::Create(tags.at(0));
// while (!enumer.IsEnd()) {
//     FileAttr attr = enumer.GetFileAttr();
//     tstring temp_file_path = MakeTempFilePath();
//     enumer.ExtractFile(temp_file_path);
//     // Do something...
//     enumer.Next();
// }
//

class FileRepo
{
public:
    virtual ~FileRepo() {}

    static FileRepo *Create(const tstring &repo_dir);

    virtual int AddFile(const tstring &file_path, const FileAttr &file_attr) = 0;

    virtual int AddDir(const FileAttr &file_attr) = 0;

    virtual int RemoveFile(const FileAttr &file_attr) = 0;

    virtual int CreateTag(const std::string &info) = 0;

    virtual int GetAllTags(std::vector<FileRepoTag> *tag_list) = 0;

    virtual int RemoveTag(const FileRepoTag &tag) = 0;

    // Get the version of the file repository
    virtual int GetVersion() = 0;

    // Free memory
    virtual void Clear() = 0;
};

} // namespace filerepo
#endif
