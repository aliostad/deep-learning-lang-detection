

#include "syncer.h"
#include "mds.h"

extern MDS* mds;

void Syncer::pullRepo(HostInfo &localHost,
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

void Syncer::checkRepo(HostInfo &infoSnapshot, const std::string &uuid)
{
    std::map<std::string, HostInfo *> hostSnapshot;
    std::map<std::string, HostInfo *>::iterator it;
    RepoInfo localInfo = infoSnapshot.getRepo(uuid);

    hostSnapshot = MDS::instance().hosts;

    for (it = hostSnapshot.begin(); it != hostSnapshot.end(); it++) {
    	std::list<std::string> repos = it->second->listRepos();
    	std::list<std::string>::iterator rIt;

        for (rIt = repos.begin(); rIt != repos.end(); rIt++) {
            RepoInfo info = it->second->getRepo(uuid);

            if (info.getHead() != localInfo.getHead()) {
                pullRepo(infoSnapshot, *(it->second), uuid);
            }
        }
    }
}

void Syncer::run()
{
    while (!interruptionRequested()) {
        HostInfo infoSnapshot;
        std::list<std::string> repos;
        std::list<std::string>::iterator it;

        infoSnapshot = MDS::instance().myInfo;
        repos = infoSnapshot.listRepos();

        for (it = repos.begin(); it != repos.end(); it++) {
            LOG("Syncer checking %s", (*it).c_str());
            checkRepo(infoSnapshot, *it);
        }

        sleep(MDS_SYNCINTERVAL);
    }

    DLOG("Syncer exited!");
}
