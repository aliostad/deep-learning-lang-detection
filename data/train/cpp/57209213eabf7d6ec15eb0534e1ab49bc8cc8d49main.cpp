// File:  main.cpp
// Date:  11/19/2015
// Auth:  K. Loux
// Desc:  Application entry point for checking git repo status.

// Standard C++ headers
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <utility>

// Local headers
#include "gitInterface.h"
#include "fileSystemNavigator.h"

int main(int argc, char *argv[])
{
	std::string gitVersion = GitInterface::GetGitVersion();
	if (gitVersion.empty())
	{
		std::cerr << "Failed to find git.  Make sure it is installed and on your path." << std::endl;
		return 1;
	}
	std::cout << gitVersion << std::endl;

	if (argc < 2)
	{
		std::cerr << "" << std::endl;
		return 1;
	}
	std::string searchPath(argv[1]);
	if (searchPath.back() != '/')
		searchPath.append("/");

	GitInterface gitIface;
	std::string repoPath;
	std::vector<GitInterface::RepositoryInfo> repoInfo;
	std::vector<std::string> directories(
		FileSystemNavigator::GetAllSubdirectories(searchPath));
	unsigned int i, repoCount(0), ignoreCount(0), nonRepoCount(0);
	const std::string ignoreFileName(".ignore");
	bool needsSpace(false);
	for (i = 0; i < directories.size(); i++)
	{
		repoPath = searchPath + directories[i] + "/";
		std::ifstream ignoreFile((repoPath + ignoreFileName).c_str());
		if (ignoreFile.is_open())
		{
			ignoreCount++;
			continue;
		}

		repoInfo.push_back(GitInterface::GetRepositoryInfo(repoPath));
		if (repoInfo.back().isGitRepository)
		{
			repoCount++;
			if (repoInfo.back().uncommittedChanges ||
				repoInfo.back().unstagedChanges ||
				repoInfo.back().untrackedFiles)
			{
				if (needsSpace)
					std::cout << "\n";

				std::cout << repoInfo.back().name << "\n";
				if (repoInfo.back().uncommittedChanges)
					std::cout << "  -> Uncommitted changes\n";
				if (repoInfo.back().unstagedChanges)
					std::cout << "  -> Unstaged changes\n";
				if (repoInfo.back().untrackedFiles)
					std::cout << "  -> Untracked files\n";

				std::cout << std::endl;
				needsSpace = false;
			}
			else if (repoInfo.back().remotes.size() == 0)
			{
				std::cout << "No remotes for " << repoInfo.back().name << std::endl;
				needsSpace = true;
			}
			else
			{
				std::string errorList;
				if (gitIface.FetchAll(repoPath, errorList))
				{
					bool printedName(false);
					unsigned int j, k;
					for (j = 0; j < repoInfo.back().remotes.size(); j++)
					{
						for (k = 0; k < repoInfo.back().branches.size(); k++)
						{
							GitInterface::RepositoryStatus status =
								GitInterface::CompareHeads(repoPath,
								repoInfo.back(), repoInfo.back().remotes[j].name,
								repoInfo.back().branches[k].name);

							if (status != GitInterface::StatusUpToDate)
							{
								if (!printedName)
								{
									if (needsSpace)
										std::cout << "\n";
									std::cout << repoInfo.back().name;
									printedName = true;
								}
									
								std::cout << "\n ==> "
									<< repoInfo.back().remotes[j].name
									<< ":" << repoInfo.back().branches[k].name;

								if (status == GitInterface::StatusLocalAhead ||
									status == GitInterface::StatusRemoteMissingBranch)
								{
									if (gitIface.PushToRemote(repoPath,
										repoInfo.back().remotes[j].name,
										repoInfo.back().branches[k].name))
										std::cout << " is now up-to-date";
									else
										std::cout << " push failed";
								}
								else if (status == GitInterface::StatusRemoteAhead)
								{
									// if (ff possible)
									// merge
									// else
									// See:  http://stackoverflow.com/questions/15316601/in-what-cases-could-git-pull-be-harmful
									std::cout << " has diverged from remote and requires user action";
								}
								else if (status == GitInterface::StatusLocalMissingBranch)
								{
									std::cout << " branch does not exist locally";
								}

								
							}
						}
					}

					if (printedName)
					{
						std::cout << "\n" << std::endl;
						needsSpace = false;
					}
				}
				else
				{
					if (needsSpace)
						std::cout << "\n";

					std::cout << repoInfo.back().name << "\n";
					std::cout << errorList << std::endl;
					needsSpace = false;
				}
			}
		}
		else
		{
			nonRepoCount++;
			/*std::cout << repoInfo.back().name << " is not a git repository" << std::endl;
			needsSpace = true;*/
		}
	}

	if (repoCount == 0)
	{
		std::cout << "Failed to find any git repositories under '" << searchPath << "'" << std::endl;
		return 0;
	}

	std::cout << "\nChecked " << repoCount << " git repositories" << std::endl;
	std::cout << "Skipped " << nonRepoCount << " directories which did not contain repositories" << std::endl;
	std::cout << "Ignored " << ignoreCount << " directories" << std::endl;

	return 0;
}
