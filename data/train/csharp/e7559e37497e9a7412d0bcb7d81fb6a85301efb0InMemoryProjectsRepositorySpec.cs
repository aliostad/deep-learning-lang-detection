using System;
using Frog.Domain.Integration;
using Frog.Domain.Integration.ProjectRepository;
using NUnit.Framework;

namespace Frog.Domain.IntegrationTests.ProjectRepository
{
	[TestFixture]
    public class InMemoryProjectsRepositorySpec : ProjectsRepositorySpec
    {
        protected override Tuple<ProjectsRepository, ProjectsRepositoryTestSupport> GetProjectsRepository()
        {
            var repository = new InMemoryProjectsRepository();
            return new Tuple<ProjectsRepository, ProjectsRepositoryTestSupport>(repository, repository);
        }
    }
}