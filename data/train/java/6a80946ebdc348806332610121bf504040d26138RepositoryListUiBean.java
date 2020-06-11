package it.cosenonjaviste.dagger.v2di;

import it.cosenonjaviste.dagger.Repository;

import java.io.IOException;

/**
 * Created by fabiocollini on 31/12/13.
 */
public class RepositoryListUiBean {
    private RepositoryService repositoryService;

    public RepositoryListUiBean(RepositoryService repositoryService) {
        this.repositoryService = repositoryService;
    }

    public void printRepositories() {
        try {
            Repository[] repositories = repositoryService.retrieveRepositories();
            for (Repository repository : repositories) {
                System.out.println(repository.getName() + " - " + repository.getDescription());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
