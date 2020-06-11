class GitHubBuildMetadata:
    def __init__(self, repository, api):
        self.repository = repository
        self.api = api

    def execute(self, batch=500):
        print('GitHub - sync metadata of repositories (as: {})'.format(self.api.username if self.api.username != '' else 'anonymous'))
        repositories = self.repository.get_repository_to_update_metadata(batch)
        while(True):
            for repository in repositories:
                try:
                    print('Repository #{}: {}'.format(repository['id'], repository['full_name']))
                    metadata = self.api.get_repository_metadata(repository['full_name'])
                    self.repository.update_repository_metadata(repository['id'], metadata)
                except GitHubRepositoryBlocked as e:
                    print('- repository blocked, omitted metadata')
                    self.repository.omit_repository_metadata(repository['id'])
                except GitHubRepositoryNotFound as e:
                    print('- repository not found, omitted metadata')
                    self.repository.omit_repository_metadata(repository['id'])