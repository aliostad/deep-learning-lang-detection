package org.plano.repository;

import org.plano.repository.dynamodb.DynamoDBRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Factory for creating {@link Repository}.
 */
@Component
public class RepositoryFactory {

    @Autowired
    private DynamoDBRepository dynamoDBRepository;

    /**
     * Create repository.
     * @param repositoryType type of repository
     * @return {@link Repository}
     */
    public Repository create(RepositoryType repositoryType) {
        Repository repository = null;
        switch (repositoryType) {
            case DYNAMODB:
            default:
                repository = dynamoDBRepository;
                break;
        }

        return repository;
    }
}
