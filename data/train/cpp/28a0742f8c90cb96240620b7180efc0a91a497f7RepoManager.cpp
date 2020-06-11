
//////////////////////////////////////////////////////////////////////////
//  RepoManager.cpp - Test RepoManager class                            //
//	Language:		Visual C++ 2011      								//
//	Platform:		Dell Studio 1558, Windows 7 Pro x64 Sp1				//
//	Application:	CIS 687 / Project 4, Sp13                       	//
//	Author:			Kevin Wang, Syracuse University						//
//					kevixw@gmail.com									//
//////////////////////////////////////////////////////////////////////////


#ifdef TEST_REPO_MANAGER

#include <iostream>
#include "RepoManager.h"

//----< test stub >--------------------------------------------
void main() {
	RepoManager::load();
	Package p = RepoManager::findLatest("packageA", "default-ns");
	std::cout << "\n Find package? " << p.empty();
	RepoManager::fillDependencyVer(p);
	Package p2 = RepoManager::find("packageA", "default-ns", 1);
	std::cout << "\n Find package? 2 " << p2.empty();
	Package p3 = RepoManager::find(p);
	std::cout << "\n Find package? 3 " << p3.empty();
	RepoManager::add(p2);
	std::cout<<"\n\n";
}
#endif