class GitHubBuildIndex:
    def __init__(self, repository, api):
        self.repository = repository
        self.api = api

    def execute(self):
        print('GitHub - sync index of repositories (as: {})'.format(self.api.username if self.api.username != '' else 'anonymous'))
        while(True):
            repositories = self.api.get_repositories(self.repository.get_last_repository_id())
            for repository in repositories:
                print('Repository #{}: {}'.format(repository['id'], repository['full_name']))
                self.repository.add_repository(repository)