package zws.service.repository;

import zws.repository.RepositoryBase;

import java.util.Collection;


/**
 * The Interface RepositoryClient.
 *
 * @author ptoleti
 */
public interface RepositoryService {
  // RepositoryClient getClient(String hostName);
  /**
   * Find repository.
   *
   * @param repositoryName the repository name
   *
   * @return the repository base
   */
  RepositoryBase findRepository(String repositoryName);

  /**
   * List repositories.

   * @return the collection
   */
  Collection listRepositories();

}
