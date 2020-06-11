package com.example.vitali.githubapiclient.data.database;

import com.example.vitali.githubapiclient.data.network.model.Repository;

import java.util.List;


public interface IRepositoriesDbManager extends IDbManager {

    void addRepository(Repository repository);

    int save(Repository repository);

    void saveAll(List<Repository> repositories);

    Repository getRepository(int id);

    List<Repository> getAll();

    List<Repository> getAll(boolean isPrivate);

//    void delete(Repository repository);
}