
package org.robbins.flashcards.cassandra.repository;

import javax.inject.Inject;

import org.robbins.flashcards.cassandra.repository.domain.BatchLoadingReceiptCassandraEntity;
import org.robbins.flashcards.repository.BatchLoadingReceiptRepository;
import org.springframework.stereotype.Repository;

@Repository
public class BatchReceiptRepositoryImpl extends AbstractCrudRepositoryImpl<BatchLoadingReceiptCassandraEntity, Long> implements
        BatchLoadingReceiptRepository<BatchLoadingReceiptCassandraEntity, Long>
{
    @Inject
    private BatchReceiptCassandraRepository repository;

    @Override
    public BatchReceiptCassandraRepository getRepository() {
        return repository;
    }

}
