
#ifndef mds_repocontrol_h
#define mds_repocontrol_h

#include <libdfs/repo.h>
#include <libdfs/localrepo.h>
#include <libdfs/udsclient.h>
#include <libdfs/udsrepo.h>

class RepoControl {
public:
    RepoControl(const std::string &path);
    ~RepoControl();
    void open();
    void close();
    std::string getPath();
    std::string getUUID();
    std::string getHead();
    bool hasCommit(const std::string &objId);
    std::string pull(const std::string &host, const std::string &path);
    std::string push(const std::string &host, const std::string &path);
private:
    std::string path;
    std::string uuid;
    UDSClient *udsClient;
    UDSRepo *udsRepo;
    LocalRepo *localRepo;
};

#endif

