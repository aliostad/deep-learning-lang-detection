#ifndef REPO_H_INCLUDED 
#define REPO_H_INCLUDED 

#include <string>
#include <memory>
#include <sys/stat.h>
#include "misc.h"

class repo
{
    public:

	class invalid_uri {};

	repo(std::unique_ptr<mount> partition, std::unique_ptr<mount> iso);

	std::string get(const std::string &uri, struct stat &res);
		/* Return an absolute path to the file in the repo
		   corresponding to uri. Throw invalid_uri if the uri is
		   malformed. */

    private:
	std::unique_ptr<mount> partition;
	std::unique_ptr<mount> iso;
};

std::unique_ptr<repo> find_repo();
	/* Find and return a repository. Return a null ptr if a valid
	   repository cannot be found. */

#endif // REPO_H_INCLUDED 
