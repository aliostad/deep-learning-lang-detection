/* This is free and unencumbered software released into the public domain. */

package com.dydra.sesame;

import com.dydra.annotation.*;
import com.dydra.Dydra;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Properties;
import java.util.Set;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.RepositoryReadOnlyException;
import org.openrdf.repository.config.RepositoryConfig;
import org.openrdf.repository.config.RepositoryConfigException;
import org.openrdf.repository.manager.RemoteRepositoryManager;
import org.openrdf.repository.manager.RepositoryManager;
import org.openrdf.repository.manager.RepositoryInfo;
import org.openrdf.repository.manager.SystemRepository;

/**
 * A manager for repositories hosted on Dydra.
 *
 * This repository manager allows access to Dydra repositories similar to
 * how local repositories are accessed using the {@link
 * org.openrdf.repository.manager.LocalRepositoryManager} class.
 */
public class DydraRepositoryManager extends RemoteRepositoryManager {
  public static final String SERVER_BASE_URL_PROPERTY = "com.dydra.sesame.url";
  public static final String SERVER_BASE_URL = "http://dydra.com/sesame2";

  protected final String accountName;
  protected boolean isAuthenticated;

  public DydraRepositoryManager(@NotNull final String accountName) {
    this(accountName, System.getProperty(SERVER_BASE_URL_PROPERTY, SERVER_BASE_URL));
  }

  public DydraRepositoryManager(@NotNull final String accountName,
                                @NotNull final Properties properties) {
    this(accountName, properties.getProperty(SERVER_BASE_URL_PROPERTY, SERVER_BASE_URL));
  }

  public DydraRepositoryManager(@NotNull final String accountName,
                                @NotNull final String serverBaseURL) {
    super((serverBaseURL.endsWith("/") ? serverBaseURL : serverBaseURL + "/") +
      accountName + "/");
    this.accountName = accountName;
  }

  public boolean isAuthenticated() {
    return this.isAuthenticated;
  }

  public void setPassword(@Nullable final String password) {
    this.setUsernameAndPassword(this.accountName, password);
  }

  @Override
  public void setUsernameAndPassword(@Nullable final String userName,
                                     @Nullable final String password) {
    this.isAuthenticated = (password != null);
    if (this.isAuthenticated) {
      super.setUsernameAndPassword(userName, password);
    }
    else {
      super.setUsernameAndPassword(null, null);
    }
  }

  @Override @NotNull
  public Set<String> getRepositoryIDs()
      throws RepositoryException {
    final Collection<RepositoryInfo> infos = this.getAllRepositoryInfos(false);
    final Set<String> result = new LinkedHashSet<String>(infos.size());
    for (final RepositoryInfo info : infos) {
      result.add(info.getId());
    }
    return result;
  }

  @Override
  public boolean hasRepositoryConfig(@NotNull final String repositoryID)
      throws RepositoryException, RepositoryConfigException {
    return this.getRepositoryIDs().contains(repositoryID);
  }

  @Override @Nullable
  public RepositoryConfig getRepositoryConfig(@NotNull final String repositoryID)
      throws RepositoryException, RepositoryConfigException {
    final RepositoryInfo repositoryInfo = this.getRepositoryInfo(repositoryID);
    return (repositoryInfo == null) ? null :
      new RepositoryConfig(repositoryID, repositoryInfo.getDescription());
  }

  @Override @Nullable
  protected Repository createSystemRepository()
      throws RepositoryException {
    DydraRepository repository = new DydraRepository(this.getServerURL(), SystemRepository.ID);
    //repository.setUsernameAndPassword(this.username, this.password); // FIXME
    repository.initialize();
    return repository;
  }

  @Override @Nullable
  protected Repository createRepository(@NotNull final String repositoryID)
      throws RepositoryException, RepositoryConfigException {
    DydraRepository repository = null;
    if (this.hasRepositoryConfig(repositoryID)) {
      repository = new DydraRepository(this.getServerURL(), repositoryID);
      //repository.setUsernameAndPassword(this.username, this.password); // FIXME
      repository.initialize();
    }
    return repository;
  }

  /**
   * @throws RepositoryReadOnlyException
   */
  @Override
  public void addRepositoryConfig(@NotNull final RepositoryConfig config)
      throws RepositoryException, RepositoryConfigException {
    failSystemRepositoryWrite();
  }

  /**
   * @throws RepositoryReadOnlyException
   */
  @Override
  public boolean removeRepositoryConfig(@NotNull final String repositoryID)
      throws RepositoryException, RepositoryConfigException {
    failSystemRepositoryWrite();
    return false; /* never reached */
  }

  protected void failSystemRepositoryWrite()
      throws RepositoryReadOnlyException {
    throw new RepositoryReadOnlyException(SystemRepository.ID + " repository is not writable");
  }
}
