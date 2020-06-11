package com.peergreen.prototype.basic;

import java.util.HashMap;
import java.util.Map;

import com.peergreen.prototype.api.Repository;
import com.peergreen.prototype.api.RepositoryProvider;

public class BasicRepositoryProvider implements RepositoryProvider {

    private final Map<String, Repository> repositories;

    public BasicRepositoryProvider() {
        this.repositories = new HashMap<String, Repository>();
    }

    @Override
    public Repository getRepository(String repositoryName) {
        Repository repository = repositories.get(repositoryName);
        if (repository == null) {
            repository = new BasicRepository(repositoryName);
            repositories.put(repositoryName, repository);
        }
        return repository;
    }

}
