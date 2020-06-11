package org.robbins.flashcards.springdata.repository;

import org.robbins.flashcards.model.BatchLoadingReceipt;
import org.robbins.flashcards.repository.BatchLoadingReceiptRepository;
import org.springframework.stereotype.Repository;

import javax.inject.Inject;

@Repository
public class BatchLoadingReceiptRepositoryImpl extends AbstractCrudRepositoryImpl<BatchLoadingReceipt, Long> implements
        BatchLoadingReceiptRepository<BatchLoadingReceipt, Long> {

    @Inject
    private BatchLoadingReceiptSpringDataRepository repository;

    @Override
    public BatchLoadingReceiptSpringDataRepository getRepository() {
        return repository;
    }
}
