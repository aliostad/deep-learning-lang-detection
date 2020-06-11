package com.fbosch.assignment.githubrepositories.data.local;


import com.fbosch.assignment.githubrepositories.data.RepositoryDataSource;
import com.fbosch.assignment.githubrepositories.data.model.Repository;

import java.util.List;

import javax.inject.Inject;

import io.reactivex.Flowable;

public class RepositoryLocalDataSource implements RepositoryDataSource {

    private RepositoryDao repositoryDao;

    @Inject
    public RepositoryLocalDataSource(RepositoryDao repositoryDao) {
        this.repositoryDao = repositoryDao;
    }

    @Override
    public Flowable<List<Repository>> getRepositories(boolean forceRemote, int page) {
        return repositoryDao.getAllRepositories();
    }

    @Override
    public void saveRepository(Repository repository) {
        repositoryDao.saveRepository(repository);
    }

}