using Test.Domain.Repositories;

namespace Test.Domain.Sagas.Steps.AddGitHubRepository
{
    public class AddGitHubRepositoryServices
    {
        public readonly BaseRepository GitHubRepositoryRepository;
        public readonly GitHubProjectRepository GitHubProjectRepository;

        public AddGitHubRepositoryServices(BaseRepository gitHubRepositoryRepository, GitHubProjectRepository gitHubProjectRepository)
        {
            this.GitHubRepositoryRepository = gitHubRepositoryRepository;
            this.GitHubProjectRepository = gitHubProjectRepository;
        }
    }
}
