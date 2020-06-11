package cz.codeland.hackerhub;

import cz.codeland.hackerhub.repository.GitHubRepository;
import cz.codeland.hackerhub.repository.GitHubRepositoryPicker;
import cz.codeland.hackerhub.repository.Repository;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class GitHubRepositoryChooserTest
{
  @Test
  public void testListRepositories() throws Exception
  {
    GitHubRepositoryPicker repositoryPicker = new GitHubRepositoryPicker();
    List<Repository> repositories = new ArrayList<>();
    repositories.add(new GitHubRepository("name1", "homepage1"));
    repositories.add(new GitHubRepository("name2", "homepage2"));
    repositories.add(new GitHubRepository("name3", "homepage3"));
    repositoryPicker.listRepositories(repositories);
  }
}
