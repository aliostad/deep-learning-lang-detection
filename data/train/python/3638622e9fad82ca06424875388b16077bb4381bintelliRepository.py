'''
Represents a GitHub repository

@since 1.0
@author Oskar Jarczyk
'''


class MyRepository():

    element_type = 'Team'
    key = None

    def __init__(self):
        self.data = []

    repository_branches = None
    repository_commits = None
    repository_contributors = None
    repository_contributors_count = None
    repository_created_at = None
    repository_default_branch = None
    repository_description = None
    repository_is_fork = None
    repository_forks = None
    repository_forks_count = None
    repository_has_downloads = None
    repository_has_issues = None
    repository_has_wiki = None
    repository_has_forks = None
    repository_homepage = None
    repository_integrate_branch = None
    repository_issues = None
    repository_labels = None
    repository_language = None
    repository_master_branch = None
    repository_name = None
    repository_open_issues = None
    repository_organization = None
    repository_owner = None
    repository_private = None
    repository_pulls = None
    repository_pulls_count = None
    repository_pushed_at = None
    repository_updated_at = None
    repository_size = None
    repository_stargazers_count = None
    repository_subscribers = None
    repository_watchers = None
    repository_url = None
    repository_network_count = None
    repo_object = None

    def setRepoObject(self, repoobject):
        self.repo_object = repoobject

    def getRepoObject(self):
        return self.repo_object

    def setKey(self, key):
        self.key = key

    def getKey(self):
        return self.key

    def setUrl(self, url):
        self.repository_url = url

    def getUrl(self):
        return self.repository_url

    def purge(self):
        'TO DO: implement this method'

    'basicly first init of data transcripted from input (csvs)'
    'name with owner, and count of forks and watchers'
    def setInitials(self, name, owner, watchers=None, forks=None):
        self.repository_name = name
        self.repository_owner = owner
        self.repository_watchers_count = watchers
        self.repository_forks_count = forks

    def setName(self, name):
        self.repository_name = name

    def getName(self):
        return self.repository_name

    def setOrganization(self, repository_organization):
        self.repository_organization = repository_organization

    def getOrganization(self):
        return self.repository_organization

    def setDescription(self, repository_description):
        self.repository_description = repository_description

    def getDescription(self):
        return self.repository_description

    def setOwner(self, owner):
        self.repository_owner = owner

    def getOwner(self):
        return self.repository_owner

    def setCreatedAt(self, repository_created_at):
        self.repository_created_at = repository_created_at

    def getCreatedAt(self):
        return self.repository_created_at

    def setDefaultBranch(self, repository_default_branch):
        self.repository_default_branch = repository_default_branch

    def getDefaultBranch(self):
        return self.repository_default_branch

    def setForks(self, forks):
        self.repository_forks = forks

    def getForks(self):
        return self.repository_forks

    def setHasDownloads(self, repository_has_downloads):
        self.repository_has_downloads = repository_has_downloads

    def getHasDownloads(self):
        return self.repository_has_downloads

    def setHasWiki(self, repository_has_wiki):
        self.repository_has_wiki = repository_has_wiki

    def getHasWiki(self):
        return self.repository_has_wiki

    def setHasIssues(self, repository_has_issues):
        self.repository_has_issues = repository_has_issues

    def getHasIssues(self):
        return self.repository_has_issues

    # def setHasForks(self, repository_has_forks):
    #     self.repository_has_forks = repository_has_forks

    # def getHasForks(self):
    #     return self.repository_has_forks

    def setIsFork(self, repository_is_fork):
        self.repository_is_fork = repository_is_fork

    def getIsFork(self):
        return self.repository_is_fork

    def setCommits(self, commits):
        self.repository_commits = commits

    def getCommits(self):
        return self.repository_commits

    def getCommitsCount(self):
        return (len(self.repository_commits) if self.repository_commits is not None else 0)

    def setForksCount(self, repository_forks_count):
        self.repository_forks_count = repository_forks_count

    def getForksCount(self):
        return self.repository_forks_count

    def setWatchers(self, watchers):
        self.repository_watchers = watchers

    def getWatchers(self):
        return self.repository_watchers

    def getWatchersCount(self):
        return self.repository_watchers_count

    def setWatchersCount(self, repository_watchers_count):
        self.repository_watchers_count = repository_watchers_count

    def setContributors(self, contributors):
        self.repository_contributors = contributors

    def getContributors(self):
        return self.repository_contributors

    def getContributorsCount(self):
        return self.repository_contributors_count

    def setContributorsCount(self, repository_contributors_count):
        self.repository_contributors_count = repository_contributors_count

    def setSubscribers(self, subscribers):
        self.repository_subscribers = subscribers

    def getSubscribers(self,):
        return self.repository_subscribers

    def getSubscribersCount(self):
        return (len(self.repository_subscribers) if self.repository_subscribers is not None else 0)

    def setStargazersCount(self, stargazers_count):
        self.repository_stargazers_count = stargazers_count

    def getStargazersCount(self):
        return self.repository_stargazers_count

    def setLanguage(self, languages):
        self.repository_language = languages

    def getLanguage(self):
        return self.repository_language

    def setLabels(self, labels):
        self.repository_labels = labels

    def getLabels(self):
        return self.repository_labels

    def getLabelsCount(self):
        return (len(self.repository_labels) if self.repository_labels is not None else 0)

    def setIssues(self, issues):
        self.repository_issues = issues

    def getIssues(self):
        return self.repository_issues

    def setPushedAt(self, repository_pushed_at):
        self.repository_pushed_at = repository_pushed_at

    def getPushedAt(self):
        return self.repository_pushed_at

    def setUpdatedAt(self, repository_updated_at):
        self.repository_updated_at = repository_updated_at

    def getUpdatedAt(self):
        return self.repository_updated_at

    def setOpenedIssues(self, repository_open_issues):
        self.repository_open_issues = repository_open_issues

    def getOpenedIssues(self):
        return self.repository_open_issues

    def setMasterBranch(self, repository_master_branch):
        self.repository_master_branch = repository_master_branch

    def getMasterBranch(self):
        return self.repository_master_branch

    def setNetworkCount(self, repository_network_count):
        self.repository_network_count = repository_network_count

    def getNetworkCount(self):
        return self.repository_network_count

    def getIssuesCount(self):
        return (len(self.repository_issues) if self.repository_issues is not None else 0)

    def setBranches(self, branches):
        self.repository_branches = branches

    def setPulls(self, pulls):
        self.repository_pulls = pulls

    def setPullsCount(self, repository_pulls_count):
        self.repository_pulls_count = repository_pulls_count

    def getPulls(self):
        return self.repository_pulls

    def getPullsCount(self):
        return self.repository_pulls_count

    def getLanguages(self):
        return self.repository_language
