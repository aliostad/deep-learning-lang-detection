

#ifndef libdfs_remoterepo_h
#define libdfs_remoterepo_h

#include <string>
//#include <boost/tr1/memory.hpp>
#include <memory>

#include "repo.h"
#include "httpclient.h"
#include "sshclient.h"
#include "udsclient.h"

class RemoteRepo
{
public:
    typedef std::shared_ptr<RemoteRepo> sp;

    RemoteRepo();
    ~RemoteRepo();
    bool connect(const std::string &url);
    void disconnect();
    Repo *operator->();
    Repo *get();

    const std::string &getURL() const {
        return url;
    }
private:
    Repo *r;
    std::shared_ptr<HttpClient> hc;
    std::shared_ptr<SshClient> sc;
    std::shared_ptr<UDSClient> uc;
    std::string url;
};

#endif

