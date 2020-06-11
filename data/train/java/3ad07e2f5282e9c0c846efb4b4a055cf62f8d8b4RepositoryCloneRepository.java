package com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.repository;

import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.Repository;
import com.cezarykluczynski.carmen.integration.vendor.github.com.repository.model.entity.RepositoryClone;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RepositoryCloneRepository extends JpaRepository<RepositoryClone, Long>,
        RepositoryCloneRepositoryCustom {

    RepositoryClone findByRepository(Repository repositoryEntity);

    RepositoryClone findFirstByCommitsStatisticsUntilIsNullAndServerIdOrderByUpdated(String serverId);

    RepositoryClone findFirstByCommitsStatisticsUntilIsNotNullAndServerIdOrderByCommitsStatisticsUntil(String serverId);

}
