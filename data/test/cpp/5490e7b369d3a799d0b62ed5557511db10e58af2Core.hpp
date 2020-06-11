#ifndef ___INANITY_OIL_CORE_HPP___
#define ___INANITY_OIL_CORE_HPP___

#include "oil.hpp"
#include "../inanity/script/script.hpp"
#include "../inanity/script/np/np.hpp"
#include "../inanity/meta/decl.hpp"
#include "../inanity/String.hpp"

BEGIN_INANITY

class FileSystem;
class File;

END_INANITY

BEGIN_INANITY_SCRIPT

class Any;

END_INANITY_SCRIPT

BEGIN_INANITY_NP

class State;

END_INANITY_NP

BEGIN_INANITY_OIL

class ClientRepo;
class RemoteRepo;
class ScriptRepo;
class EntitySchemeManager;
class Engine;

class Core : public Object
{
private:
	ptr<Script::Np::State> scriptState;
	ptr<FileSystem> nativeFileSystem;
	ptr<EntitySchemeManager> entitySchemeManager;
	String profilePath;
	ptr<FileSystem> profileFileSystem;

	ptr<Engine> engine;

public:
	Core(ptr<Script::Np::State> scriptState);

	ptr<Script::Any> GetRootNamespace() const;
	ptr<FileSystem> GetNativeFileSystem() const;
	ptr<FileSystem> GetProfileFileSystem() const;
	void SetProfilePath(const String& profilePath);

	void Init();

	ptr<ClientRepo> CreateLocalClientRepo(const String& fileName);
	ptr<ClientRepo> CreateTempClientRepo();
	ptr<ClientRepo> CreateMemoryClientRepo();

	ptr<RemoteRepo> CreateUrlRemoteRepo(const String& url);
	ptr<RemoteRepo> CreateLocalRemoteRepo(const String& fileName);
	ptr<RemoteRepo> CreateTempRemoteRepo();
	ptr<RemoteRepo> CreateMemoryRemoteRepo();

	ptr<ScriptRepo> CreateScriptRepo(ptr<ClientRepo> clientRepo, ptr<RemoteRepo> remoteRepo);

	ptr<Engine> GetEngine() const;

	META_DECLARE_CLASS(Core);
};

END_INANITY_OIL

#endif
