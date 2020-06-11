package com.okysoft.githubmvp.domain.usecase;

import com.okysoft.githubmvp.domain.entity.Repository;
import com.okysoft.githubmvp.domain.repository.RepositoryRepository;
import com.okysoft.githubmvp.domain.repository.UserRepository;

import java.util.List;

/**
 * Created by oyuk on 2016/01/21.
 */
public class RepositoryUseCaseImpl implements RepositoryUseCase{
    private RepositoryRepository repositoryRepository;

    public RepositoryUseCaseImpl(RepositoryRepository repositoryRepository){
        this.repositoryRepository = repositoryRepository;
    }

    @Override
    public List<Repository> request() {
        repositoryRepository.getRepository();
        return null;
    }

}
