
#ifndef mds_repomonitor_h
#define mds_repomonitor_h

#include "mds.h"

class RepoMonitor : public Thread
{
public:
    RepoMonitor() : Thread() {
    }
    /*
     * Update repository information and return thre repoId, otherwise empty 
     * string.
     */
    void updateRepo(const string &path) {
        RepoControl repo = RepoControl(path);
        RepoInfo info;

        try {
            repo.open();
        } catch (SystemException &e) {
            WARNING("Failed to open repository %s: %s", path.c_str(), e.what());
            return;
        }

        RWKey::sp key = infoLock.writeLock();
        if (myInfo.hasRepo(repo.getUUID())) {
            info = myInfo.getRepo(repo.getUUID());
        } else {
            info = RepoInfo(repo.getUUID(), repo.getPath());
        }
        info.updateHead(repo.getHead());
        myInfo.updateRepo(repo.getUUID(), info);

        LOG("Checked %s: %s %s", path.c_str(), repo.getHead().c_str(), repo.getUUID().c_str());
        
        repo.close();

        return;
    }
    void run() {
        list<string> repos = rc.getRepos();
        list<string>::iterator it;

        while (!interruptionRequested()) {
            for (it = repos.begin(); it != repos.end(); it++) {
                updateRepo(*it);
            }

            sleep(MDS_MONINTERVAL);
        }

        DLOG("RepoMonitor exited!");
    }
};

#endif