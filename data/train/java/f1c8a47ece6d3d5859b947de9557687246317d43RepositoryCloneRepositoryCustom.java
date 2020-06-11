package com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.repository;

import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.Repository;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.RepositoryClone;
import com.cezarykluczynski.carmen.vcs.server.Server;

public interface RepositoryCloneRepositoryCustom {

    RepositoryClone createStubEntity(Server server, Repository repositoryEntity);

    RepositoryClone truncateEntity(Server server, RepositoryClone repositoryCloneEntity);

    void setStatusToCloned(RepositoryClone repositoryEntity);

    RepositoryClone findRepositoryCloneWithCommitsToPersist();

}
