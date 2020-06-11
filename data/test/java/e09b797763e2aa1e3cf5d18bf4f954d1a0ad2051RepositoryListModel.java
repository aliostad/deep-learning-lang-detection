package client.model;

import domain.Repository;

import java.util.SortedSet;
import java.util.List;

public interface RepositoryListModel {
    public SortedSet <Repository> getRepositories();
    public void setRepositories(SortedSet <Repository> repositories);
    public void reset();
    public void addRepository(Repository repository);
    public void removeRepository(Repository repository);
    public Repository getSelectedItem();
    public void setSelectedItem(Repository repository);
    public void setRepositoryListModelListeners(List repositoryListModelListeners);
}
