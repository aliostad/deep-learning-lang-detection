"""AppAssure 5 REST API"""

from appassure.api import AppAssureAPI

class IRepositoryManagement(AppAssureAPI):
    """Full documentation online at
    http://docs.appassure.com/display/AA50D/IRepositoryManagement
    """

    def getConfiguration(self):
        """Retrieves the current configuration of the repository
        service.
        """
        return self.session.request('reposManagement/config')

    def setConfiguration(self, data):
        """Sets the configuration of the repository service."""
        return self.session.request('reposManagement/config', 'POST',
                    self.getXML(data, 'reposServiceConfig'))

    def applyDefaultDeduplicationCacheConfiguration(self):
        """Create default deduplication cache configuration."""
        return self.session.request('reposManagement/defaults', 'PUT')

    def getFreeDiskSpace(self, data):
        """Gets the free space in the directory or UNC share."""
        return self.session.request('reposManagement/getFreeDiskSpace', 'POST',
                    self.getXML(data, 'freeSpaceRequest'))

    def create(self, data):
        """Creates a new repository."""
        return self.session.request('reposManagement/repositories', 'PUT',
                    self.getXML(data, 'newRepos'))

    def getRepositories(self):
        """Gets a list of all repositories, including
        configuration and status.
        """
        return self.session.request('reposManagement/repositories')

    def updateWriteCachePolicy(self, data, repositoryId):
        """Updates files write caching policies."""
        return self.session.request('reposManagement/repositories/%s/writePolicy'
                % (repositoryId), 'PUT',
                    self.getXML(data, 'reposUpdateWriteCachingPolicies'))

    def verifyFileSpecifications(self, data):
        """Verifies paths and free space on the specified devices."""
        return self.session.request('reposManagement/repositories/verifyFileSpecifications', 'POST',
                    self.getXML(data, 'reposFilesSpec'))

    def verifyNetworkCredentials(self, data):
        """Verifies network credentials for specified paths."""
        return self.session.request('reposManagement/repositories/verifyNetworkCredentials', 'POST',
                    self.getXML(data, 'reposFilesSpec'))

    def getRepositoryById(self, id):
        """Gets the configuration and status information for a
        repository.
        """
        return self.session.request('reposManagement/repositories/%s/id'
                % (id))

    def getRepositoryUsage(self, id):
        """Gets the current uses of a specified repository."""
        return self.session.request('reposManagement/repositories/%s/usage'
                % (id))

    def deleteRepository(self, repositoryId):
        """Deletes the specified repository and all data therein."""
        return self.session.request('reposManagement/repositories/%s'
                % (repositoryId))

    def renameRepository(self, repositoryId, newReposName):
        """Renames a repository."""
        return self.session.request('reposManagement/repositories/%s/%s/rename'
                % (repositoryId, newReposName), 'POST')

    def appendRepositoryFiles(self, data, repositoryId):
        """Appends and mounts additional files to a live
        repository.
        """
        return self.session.request('reposManagement/repositories/%s/append'
                % (repositoryId), 'POST',
                    self.getXML(data, 'reposFilesSpec'))

    def checkRepositoryIntegrityEstimate(self, repositoryId):
        """Estimates repository check job duration.
        checkRepositoryIntegrityEstimate.
        """
        return self.session.request('reposManagement/repositories/%s/'
                % (repositoryId))

    def setRepositoryFileSpecification(self, data, repositoryId, repositoryFileId):
        """Updates a repository file specification."""
        return self.session.request('reposManagement/repositories/%s/file/%s'
                % (repositoryId, repositoryFileId), 'PUT',
                    self.getXML(data, 'reposFilesSpec'))

    def getRepositoryFile(self, repositoryId, fileId):
        """Gets the configuration and status information for a
        repository file.
        """
        return self.session.request('reposManagement/repositories/%s/files/%s'
                % (repositoryId, fileId))

    def reformatRepository(self, repositoryId):
        """Reformats the repository, deleting any existing
        recovery points.
        """
        return self.session.request('reposManagement/repositories/%s/format'
                % (repositoryId), 'POST')

    def getRepositoryCacheInfo(self, repositoryId):
        """Gets the repository cache info."""
        return self.session.request('reposManagement/repositories/%s/getRepositoryCacheInfo'
                % (repositoryId), 'POST')

    def isRepositoryMounted(self, repositoryId):
        """Verify paths are reachable for a given repository."""
        return self.session.request('reposManagement/repositories/%s/isRepositoryMounted'
                % (repositoryId), 'POST')

    def setRepositoryCacheParameters(self, data, repositoryId):
        """Updates a repository cache parameters."""
        return self.session.request('reposManagement/repositories/%s/setRepositoryCacheParameters'
                % (repositoryId), 'PUT',
                    self.getXML(data, 'repositoryCacheParameters'))

    def verifyPaths(self, repositoryId):
        """Verify paths are reachable for a given repository."""
        return self.session.request('reposManagement/repositories/%s/verifyPaths'
                % (repositoryId), 'POST')

    def addExistentByConfigurations(self, data):
        """Loads one or several existing repositories."""
        return self.session.request('reposManagement/repositories/addexistentbyconfigurations', 'POST',
                    self.getXML(data, 'repositoryConfigurations'))

    def addExistentWithIds(self, data):
        """Load existent repositories by guid list."""
        return self.session.request('reposManagement/repositories/addexistentwithids', 'POST',
                    self.getXML(data, 'addrepositoriesdirectory'))

    def checkRepository(self, data):
        """Checks a repository."""
        return self.session.request('reposManagement/repositories/check', 'POST',
                    self.getXML(data, 'checkRepositoryRequest'))

    def checkRepositoryIntegrity(self, data):
        """Checks the repository integrity."""
        return self.session.request('reposManagement/repositories/checkRepositoryIntegrity', 'POST',
                    self.getXML(data, 'checkRepositoryIntegrityRequest'))

    def getFailedDirectories(self):
        """Gets repositories directories' paths that do not pass
        validation.
        """
        return self.session.request('reposManagement/repositories/failedDirectories')

    def getExistent(self, data):
        """Shows the list of the existent repositories described
        by the configuration file at the specified directory.
        """
        return self.session.request('reposManagement/repositories/getexistent', 'POST',
                    self.getXML(data, 'repositoryDirectory'))

    def getRepositoriesCacheInfo(self):
        """Gets all repositories cache info."""
        return self.session.request('reposManagement/repositories/getRepositoriesCacheInfo', 'POST')

    def isRepoErrors(self):
        """Checks if there any repository with errors. Returns
        true if at least one repository contains error(s).
        """
        return self.session.request('reposManagement/repositories/isRepoErrors')

    def moveRepositoryFile(self, data):
        """Moves a repository file."""
        return self.session.request('reposManagement/repositories/move', 'POST',
                    self.getXML(data, 'moveRepositoryFileRequest'))

    def updateRepositoriesDirectories(self, data):
        """Updates directories for repositories."""
        return self.session.request('reposManagement/repositories/updateDirectories', 'PUT',
                    self.getXML(data, 'RepositoriesUpdateDirectories'))

    def updateRepositorySpecification(self, data):
        """Applies a new specification to a repository."""
        return self.session.request('reposManagement/repositories/updateRepositorySpecification', 'PUT',
                    self.getXML(data, 'reposSpecUpdate'))

    def validateDirectoryPath(self, data):
        """Perform validation of specified path of the repository
        directory.
        """
        return self.session.request('reposManagement/repositories/validateDirectoryPath', 'POST',
                    self.getXML(data, 'repositoryDirectory'))

    def getRepositorySummaries(self):
        """Gets a list of all repositories, including
        configuration and status.
        """
        return self.session.request('reposManagement/repositorySummaries')
