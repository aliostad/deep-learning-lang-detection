#pragma once
#include <git2.h>

namespace Git
{
	class Repository::RepositoryPrivate
	{
	public:

	typedef struct MergeData {
		std::vector<git_annotated_commit*>* commits;
		git_repository * ptrRepo;
		RepositoryPrivate * ptrPrivateRepo;
	} MergeData;

	typedef struct CommonData
	{
		Repository * ptrRepo;
		RepositoryPrivate * ptrPrivateRepo;
	} Callback;

	RepositoryPrivate();
	virtual ~RepositoryPrivate();

	git_commit * GetLastCommit();
	int CredentialAcquireCallBack(git_cred **out, const char * url, const char * username_from_url, unsigned int allowed_types, void * payload);
	git_repository * m_ptrRepo;
	};
}
