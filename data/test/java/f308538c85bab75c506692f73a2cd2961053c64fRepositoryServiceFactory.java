package me.mziccard.please.rpc;

/**
 * Interface for {@code RepositoryService} factories.
 */
public interface RepositoryServiceFactory {

  /**
   * Get a {@code RepositoryService} service for the given options.
   *
   * @return  A {@code RepositoryService} for the requested properties.
   */
  public abstract RepositoryService get(RepositoryOptions options);

  /**
   * Get a {@code RepositoryService} service with default options.
   *
   * @return  A default {@code RepositoryService}
   */
  public abstract RepositoryService get();
};
