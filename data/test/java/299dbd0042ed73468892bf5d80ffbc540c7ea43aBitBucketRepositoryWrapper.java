package com.karlnosworthy.bitbucketclient.model.wrapper;

import com.karlnosworthy.bitbucketclient.model.BitBucketRepository;

import java.util.List;


public class BitBucketRepositoryWrapper {

    public BitBucketRepository repository;

    public List<BitBucketRepository> repositories;



    public BitBucketRepositoryWrapper() {
        super();
    }

    public BitBucketRepositoryWrapper(BitBucketRepository repository) {
        super();
        this.repository = repository;
    }

    public BitBucketRepositoryWrapper(List<BitBucketRepository> repositories) {
        super();
        this.repositories = repositories;
    }

    public boolean hasRepository() {
        return repository != null;
    }

    public BitBucketRepository getRepository() {
        return repository;
    }

    public void setRepository(BitBucketRepository repository) {
        this.repository = repository;
    }

    public boolean hasRepositories() {
        return repositories != null;
    }

    public List<BitBucketRepository> getRepositories() {
        return repositories;
    }

    public void setRepositories(List<BitBucketRepository> repositories) {
        this.repositories = repositories;
    }
}


