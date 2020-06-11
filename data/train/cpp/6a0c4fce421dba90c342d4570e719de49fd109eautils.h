#ifndef UTILS_H
#define UTILS_H

#include <string.h>

#include <zypp/RepoManager.h>
#include <zypp/RepoInfo.h>
#include <zypp/PoolItem.h>
#include <zypp/PoolQuery.h>
#include <boost/scoped_ptr.hpp>
#include "keyring.h"

using namespace std;
using namespace zypp;

class ZypperUtils
{
private:
  /******************************* Member Declarations *******************************/
  static scoped_ptr<RepoManager> s_repoManager;
  static RepoInfo s_repoInfo;
  static KeyRingReceive s_keyReceiveReport;
public:
  /**
   * Initialize Repositories 
   */
  static void initRepository( const string & repoName, const string & repoUrl );
  
  /**
   * Refresh RepoManager to query meta data of a package
   */
  static void refreshRepoManager();
  
  /**
   * Initialize RepoInfo. Needed to refresh RepoManager
   * RepoInfo contains all the information there is about a repository
   */
  static void initRepoInfo( const string & repoUrl, const string & packageName );
  
  /**
   * Add repository
   */
  static void addRepository( const string & repoUrl, const string & repoAlias = "temp" );
  
   /**
   * Return true if repository exists
   */
  static bool exists( const string & repoUrl );
 
  /**
   * Returns KeyRing report
   */
  static KeyRingReceive keyReport();
  
  /**
   * Load System repos 
   */
  static void initSystemRepos();  
  
  /**
   * Reset RepoManager
   */
  static void resetRepoManager( const Pathname & sysRoot );
};
#endif
