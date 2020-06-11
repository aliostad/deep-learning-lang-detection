using System;
using System.Collections.Generic;

using Machine.Partstore.Domain.Core;
using Machine.Partstore.Domain.Core.Repositories;

namespace Machine.Partstore.Application
{
  public class RepositorySets : IManipulateRepositorySets
  {
    private readonly ICurrentProjectRepository _currentProjectRepository;
    private readonly IRepositoryRepository _repositoryRepository;
    private readonly IRepositorySetRepository _repositorySetRepository;

    public RepositorySets(ICurrentProjectRepository currentProjectRepository, IRepositoryRepository repositoryRepository, IRepositorySetRepository repositorySetRepository)
    {
      _currentProjectRepository = currentProjectRepository;
      _repositorySetRepository = repositorySetRepository;
      _repositoryRepository = repositoryRepository;
    }

    #region IManipulateRepositories Members
    public AddingVersionResponse AddNewVersion(string repositoryName, string tags)
    {
      CurrentProject project = _currentProjectRepository.FindCurrentProject();
      if (project.BuildDirectory.IsMissing)
      {
        return new AddingVersionResponse(AddingVersionResponse.Status.NoBuildDirectory);
      }
      if (project.BuildDirectory.IsEmpty)
      {
        return new AddingVersionResponse(AddingVersionResponse.Status.BuildDirectoryEmpty);
      }
      RepositorySet repositorySet = project.RepositorySet;
      Repository repository;
      if (repositorySet.HasMoreThanOneRepository)
      {
        if (String.IsNullOrEmpty(repositoryName))
        {
          return new AddingVersionResponse(AddingVersionResponse.Status.AmbiguousRepositoryName);
        }
        repository = repositorySet.FindRepositoryByName(repositoryName);
      }
      else
      {
        repository = repositorySet.DefaultRepository;
      }

      // ArchivedProjectAndVersion version = project.CreateNewVersion();

      project.AddNewVersion(repository, new Tags(tags));
      _repositoryRepository.SaveRepository(repository);
      return new AddingVersionResponse(AddingVersionResponse.Status.Success);
    }
    
    public bool Refresh()
    {
      RepositorySet repositorySet = _repositorySetRepository.FindDefaultRepositorySet();
      repositorySet.Refresh();
      return true;
    }
    #endregion
  }
}
