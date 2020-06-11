package net.sf.anathema.platform.environment;

import net.sf.anathema.platform.repository.RepositoryPreference;
import net.sf.anathema.platform.repository.RepositoryPreferenceModel;

public class DummyInitializationPreferences implements RepositoryPreference {

  private String repositoryLocation;

  @Override
  public String getRepositoryLocationPreference() {
    if (repositoryLocation != null) {
      return repositoryLocation;
    }
    return RepositoryPreferenceModel.DEFAULT_REPOSITORY_LOCATION;
  }

  public void setRepositoryLocationPreference(String preference) {
    this.repositoryLocation = preference;
  }
}