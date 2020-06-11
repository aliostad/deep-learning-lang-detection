#ifndef ___INANITY_OIL_LOCAL_REMOTE_REPO_HPP___
#define ___INANITY_OIL_LOCAL_REMOTE_REPO_HPP___

#include "RemoteRepo.hpp"

BEGIN_INANITY_OIL

class ServerRepo;

class LocalRemoteRepo : public RemoteRepo
{
private:
	ptr<ServerRepo> serverRepo;
	ptr<DataHandler<ptr<File> > > deferredWatchHandler;

	struct WatchCallback;

public:
	LocalRemoteRepo(ptr<ServerRepo> serverRepo);

	//*** RemoteRepo's methods.
	void GetManifest(ptr<DataHandler<ptr<File> > > manifestHandler);
	void Sync(ptr<File> pushData, ptr<DataHandler<ptr<File> > > pullHandler);
	void Watch(ptr<File> requestData, ptr<DataHandler<ptr<File> > > watchHandler);
};

END_INANITY_OIL

#endif
