#include "trap.h"

#include <zypp/RepoInfo.h>
#include <zypp/Repository.h>
#include <zypp/ResPool.h>
#include <zypp/ZYpp.h>
#include <zypp/ZYppFactory.h>
#include <zypp/base/Algorithm.h>
#include <zypp/PoolQuery.h>
#include <zypp/PathInfo.h>
#include <zypp/Capability.h>
#include <zypp/sat/Solvable.h>
#include <zypp/Url.h>
#include <zypp/KeyRing.h>

#include <exception>

#include <stdio.h>
#include <unistd.h>

#define GetCurrentDir getcwd

Trap::Trap():m_pathName("/")
{	
	m_repoManager = nullptr;
	initRepoManager();
}

Trap::~Trap()
{
	if(m_repoManager != nullptr)
		delete m_repoManager;
}

void Trap::initRepoManager()
{
	try
	{
		if(m_repoManager != nullptr)
			delete m_repoManager;
		m_repoManager = new zypp::RepoManager(zypp::RepoManagerOptions(zypp::Pathname(m_pathName)));
	}
	catch (const std::exception &e)
	{
		std::cout << "[INFO] : repoManager cannot be set, exception caught : " << e.what() << std::endl;
	}
}

std::string Trap::getPackagesFromName(std::string name, std::string repoAlias)
{
	m_buildString = "";
	
	try
	{
		
		zypp::ZYpp::Ptr zyppPtr = zypp::ZYppFactory::instance().getZYpp();
		
		zypp::Pathname sysRoot( m_pathName );
		zyppPtr->initializeTarget( sysRoot, false );
		zyppPtr->target()->load();

		zypp::PoolQuery query;

		query.setCaseSensitive(false);
		query.setMatchGlob();
		
		zypp::Capability cap = zypp::Capability::guessPackageSpec( name );
		std::string newName = cap.detail().name().asString();

		query.addDependency( zypp::sat::SolvAttr::name , newName, cap.detail().op(), cap.detail().ed(), zypp::Arch(cap.detail().arch()) );
		query.addDependency( zypp::sat::SolvAttr::provides , newName, cap.detail().op(), cap.detail().ed(), zypp::Arch(cap.detail().arch()) );
		
		if(repoAlias != "")
		{
			query.addRepo(repoAlias);
		}

		//zypp::ResPool pool( ResPool::instance() );
		zyppPtr->resolver()->resolvePool();
		
			
		zypp::invokeOnEach(query.poolItemBegin(), query.poolItemEnd(), m_result);
		saveQueryResult();//save building string in the result string
		
		if(m_resultString.size() > 0)
			m_resultString.substr(0, m_resultString.size()-1);
	
	}
	catch (const std::exception &e)
	{
		std::cerr << "[ERROR] Exception caught in Trapp::getPackagesFromName : "<< e.what() << std::endl;
		return "";
	}
	return m_resultString;
}

std::string Trap::lastQueryResult()
{
	return m_resultString;
}

void Trap::setPathName(std::string pathName)
{
	if(m_pathName != pathName)
	{
		if(pathName[0] != '/')
		{
			char cCurrentPath[FILENAME_MAX];

			if (!GetCurrentDir(cCurrentPath, sizeof(cCurrentPath)))
			{
				std::cerr << "[ERROR] When trying to get the current directory : "<< errno << std::endl;
			}
			else
			{
				std::cout << "[INFO] : Changing Path from relative toAbsolute, adding : " << cCurrentPath << std::endl;
				cCurrentPath[sizeof(cCurrentPath) - 1] = '\0';
				pathName = std::string(cCurrentPath) + std::string("/") + pathName;
			}
		}
		m_pathName = pathName;
		
		initRepoManager();
		
	}
}

std::string Trap::getPathName()
{
	return m_pathName;
}

void Trap::addBuildResult(std::string addString)
{
	m_buildString += addString;
}

void Trap::setBuildResult(std::string buildString)
{
	m_buildString = buildString;
}

void Trap::saveQueryResult()
{
	m_resultString = m_buildString;
	m_resultString = m_resultString.substr(0,m_resultString.size()-1);
}

bool Trap::isRepositoryExists(std::string repoAlias)
{
	return m_repoManager->hasRepo(repoAlias);
}

bool Trap::addRepo(std::string repoAlias, std::string repoURL, std::string gpgCheckURL)
{
	if(m_repoManager->hasRepo(repoAlias))
		m_repoManager->removeRepository(m_repoManager->getRepo(repoAlias));
	if(m_repoManager->hasService(repoAlias))
		m_repoManager->removeService(repoAlias);
	
	try
	{
		zypp::repo::ServiceType stype = m_repoManager->probeService(repoURL);
		
		if (stype != zypp::repo::ServiceType::NONE) //if this is a service
		{
			//Setting service info
			zypp::ServiceInfo service;
			service.setType(stype);
			service.setAlias(repoAlias);
			service.setName(repoAlias);
			service.setUrl(repoURL);
			service.setEnabled(true);
			//Adding service or modifiy it if it already exists
			if(m_repoManager->hasService(repoAlias))
				m_repoManager->modifyService(repoAlias, service);
			else
				m_repoManager->addService(service);
			
			// Refresh repo manager and reinitialize repoManager
			initRepoManager();
		}
		else if (checkRepo(repoURL)) //If this is a repository
		{
			//Setting repository info
			zypp::RepoInfo repo;
			repo.setBaseUrl(repoURL);
			repo.setEnabled(true);
			repo.setAutorefresh(false);
			if(gpgCheckURL != "")
			{
				repo.setGpgCheck(true);
				repo.setGpgKeyUrl(zypp::Url(gpgCheckURL));
			}
			repo.setKeepPackages(false);
			repo.setAlias(repoAlias);
			repo.setName(repoAlias);
			repo.setProbedType(m_repoManager->probe(repoURL));
			
			//add repository or modify it if already exists
			if(m_repoManager->hasRepo(repoAlias))
				m_repoManager->modifyRepository(repo);
			else
				m_repoManager->addRepository(repo);
				
			//Reinitialize repoManager
			initRepoManager();
		}
	}
	catch(const std::exception &e)
	{
		std::cerr << "[ERROR] Exception caught in Trapp::addRepo : "<< e.what() << std::endl;
		return false;
	}
	
	return true;
}

bool Trap::checkRepo(std::string repoURL)
{
	try
	{
		if (m_repoManager->probe(repoURL).asString() != std::string("NONE"))
			return true;
		return false;
	}
	catch (const std::exception &e)
	{
		std::cerr << "[INFO] in Trap::checkRepo, unable to reach : " << repoURL << " (verify you are connected to the network) : Exception Caught :" << e.what() << std::endl;
		return false;
	}
}

bool Trap::refreshRepo(std::string repoAlias)
{
	//TODO : do the gpg Check. currently : accept automaticaly
	zypp::KeyRing::setDefaultAccept(zypp::KeyRing::ACCEPT_UNSIGNED_FILE | zypp::KeyRing::TRUST_AND_IMPORT_KEY);
	bool refreshSuccessfull = false;
	try 
	{
		zypp::Pathname path( m_pathName );
		zypp::ZYppFactory::instance().getZYpp()->initializeTarget( path, false );
		
		//Test if this is a service
		if(m_repoManager->hasService(repoAlias))
		{
			zypp::ServiceInfo service = m_repoManager->getService(repoAlias);
			m_repoManager->refreshService(service);
		}
		
		initRepoManager();
		zypp::RepoInfo repo = m_repoManager->getRepositoryInfo(repoAlias);
		
		for(zypp::RepoInfo::urls_const_iterator it = repo.baseUrlsBegin(); it != repo.baseUrlsEnd(); ++it)
		{
			try
			{
				
				if(m_repoManager->checkIfToRefreshMetadata (repo, *it) == zypp::RepoManager::REFRESH_NEEDED)
				{
					m_repoManager->refreshMetadata(repo, zypp::RepoManager::RefreshIfNeeded);
					m_repoManager->cleanCache(repo);
					m_repoManager->buildCache(repo, zypp::RepoManager::BuildIfNeeded);
					initRepoManager();
					refreshSuccessfull = true;
					break;
				}
			}
			catch(const std::exception &e)
			{
				std::cerr << "[ERROR] in Trap::refreshRepo : " << *it << " doesn't look good : Exception Caught :" << e.what() << std::endl;
			}
		}
		initRepoManager();
	}
	catch (const std::exception &e)
	{
		std::cerr << "[ERROR] in Trap::refreshRepo : Exception Caught :" << e.what() << std::endl;
	}
	return refreshSuccessfull;
}


std::string Trap::getAllPackages(std::string repoAlias)
{
	return getPackagesFromName("",repoAlias);
}

void Trap::clean()
{
	for(zypp::RepoManager::RepoConstIterator it = m_repoManager->repoBegin(); it !=  m_repoManager->repoEnd(); it = m_repoManager->repoBegin())
	{
		m_repoManager->cleanCache(*it);
		m_repoManager->removeRepository(*it);
	}
	initRepoManager();
	for(zypp::RepoManager::ServiceConstIterator it = m_repoManager->serviceBegin(); it !=  m_repoManager->serviceEnd(); it = m_repoManager->serviceBegin())
		m_repoManager->removeService(*it);
	initRepoManager();
}

QueryResult::QueryResult()
{
}

QueryResult::~QueryResult()
{
}

bool QueryResult::operator()( const zypp::PoolItem & pi )
{
	Trap &trap = Trap::getInstance();
	trap.addBuildResult(pi->name() + ",");
	return true;
}
