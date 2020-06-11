class GitHubUpdate:
    def __init__(self, repository, api):
        self.repository = repository
        self.api = api

    def execute(self):
        print('GitHub - update index with metadata of repositories (as: {})'.format(self.api.username if self.api.username != '' else 'anonymous'))
        while(True):
            repositories = self.api.get_repositories(self.repository.get_last_repository_id())
            for repository in repositories:
                try:
                    print('Repository #{}: {}'.format(repository['id'], repository['full_name']))
                    metadata = self.api.get_repository_metadata(repository['full_name'])
                    self.repository.add_repository(repository)
                    self.repository.update_repository_metadata(repository['id'], metadata)
                except GitHubRepositoryBlocked as e:
                    print('- repository blocked, omitted metadata')
                except GitHubRepositoryNotFound as e:
                    print('- repository not found, omitted metadata')