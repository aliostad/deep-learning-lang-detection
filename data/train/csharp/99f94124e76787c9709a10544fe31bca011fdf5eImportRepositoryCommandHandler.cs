using Logos.ApplicationServices.Commands;
using Logos.Domain;
using Logos.Domain.Core;
namespace Logos.ApplicationServices.CommandHandlers
{
    public class ImportRepositoryCommandHandler : ICqrsCommandHandler<ImportRepository>
    {
        readonly IGithubRepositoryRepository _githubRepositoryRepository;

        public ImportRepositoryCommandHandler(IGithubRepositoryRepository githubRepositoryRepository)
        {
            _githubRepositoryRepository = githubRepositoryRepository;
        }

        public void Handle(ImportRepository command)
        {
            Repository importedGithubRepository = _githubRepositoryRepository.Import(command.GithubRepositoryId, command.RepositoryName, command.Credentials);

            _githubRepositoryRepository.Save(importedGithubRepository, -1);
        }
    }
}