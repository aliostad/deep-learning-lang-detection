package com.cezarykluczynski.carmen.vcs.git.worker;

import com.cezarykluczynski.carmen.cron.management.annotations.DatabaseSwitchableJob;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.Repository;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.RepositoryClone;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.repository.RepositoryCloneRepository;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.repository.RepositoryRepository;
import com.cezarykluczynski.carmen.util.exec.result.Result;
import com.cezarykluczynski.carmen.vcs.git.GitRemote;
import com.cezarykluczynski.carmen.vcs.git.util.DirectoryNameBuilder;
import com.cezarykluczynski.carmen.vcs.server.Server;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
@DatabaseSwitchableJob
public class GitHubCloneWorker extends AbstractCloneWorker implements Runnable {

    private RepositoryRepository repositoryRepository;

    private RepositoryCloneRepository repositoryCloneRepository;

    private Server server;

    @Autowired
    public GitHubCloneWorker(RepositoryRepository repositoryRepository,
            RepositoryCloneRepository repositoryCloneRepository, Server server) {
        this.repositoryRepository = repositoryRepository;
        this.repositoryCloneRepository = repositoryCloneRepository;
        this.server = server;
    }

    @Override
    public void run() {
        Repository repositoryEntity = repositoryRepository.findFirstByRepositoryCloneIsNullAndForkFalse();
        if (repositoryEntity == null) {
            return;
        }

        RepositoryClone repositoryCloneEntity = repositoryCloneRepository.createStubEntity(server, repositoryEntity);
        if (repositoryCloneEntity == null) {
            return;
        }

        String cloneDirectory =  DirectoryNameBuilder.buildCloneDirectory(server, repositoryCloneEntity);
        Result cloneResult = clone(repositoryEntity, cloneDirectory, repositoryEntity.getFullName());

        if (cloneResult.isSuccessFul()) {
            repositoryCloneRepository.setStatusToCloned(repositoryCloneEntity);
        } else {
            repositoryCloneRepository.truncateEntity(server, repositoryCloneEntity);
        }
    }

    @Override
    protected Result clone(Repository repositoryEntity, String cloneDirectory, String originTargetName) {
        return GitRemote.clone(repositoryEntity.getCloneUrl(), cloneDirectory, originTargetName);
    }

}
