
#ifndef mds_syncer_h
#define mds_syncer_h

#include "mds.h"

class Syncer : public Thread
{
public:
    Syncer() : Thread()
    {
    }
    void pullRepo(HostInfo &localHost,
                  HostInfo &remoteHost,
                  const std::string &uuid)
    {
        RepoInfo local = localHost.getRepo(uuid);
        RepoInfo remote = remoteHost.getRepo(uuid);
        RepoControl repo = RepoControl(local.getPath());

        DLOG("Local and Remote heads mismatch on repo %s", uuid.c_str());

        repo.open();
        if (!repo.hasCommit(remote.getHead())) {
            LOG("Pulling from %s:%s",
                remoteHost.getPreferredIp().c_str(),
                remote.getPath().c_str());
            repo.pull(remoteHost.getPreferredIp(), remote.getPath());
        }
        repo.close();
    }
    void checkRepo(HostInfo &infoSnapshot, const std::string &uuid)
    {
        map<string, HostInfo *> hostSnapshot;
        map<string, HostInfo *>::iterator it;
        RepoInfo localInfo = infoSnapshot.getRepo(uuid);

        hostSnapshot = hosts;

        for (it = hostSnapshot.begin(); it != hostSnapshot.end(); it++) {
            list<string> repos = it->second->listRepos();
            list<string>::iterator rIt;

            for (rIt = repos.begin(); rIt != repos.end(); rIt++) {
                RepoInfo info = it->second->getRepo(uuid);

                if (info.getHead() != localInfo.getHead()) {
                    pullRepo(infoSnapshot, *(it->second), uuid);
                }
            }
        }
    }
    void run() {
        while (!interruptionRequested()) {
            HostInfo infoSnapshot;
            list<string> repos;
            list<string>::iterator it;

            infoSnapshot = myInfo;
            repos = infoSnapshot.listRepos();

            for (it = repos.begin(); it != repos.end(); it++) {
                LOG("Syncer checking %s", (*it).c_str());
                checkRepo(infoSnapshot, *it);
            }

            sleep(MDS_SYNCINTERVAL);
        }

        DLOG("Syncer exited!");
    }
};

#endif
