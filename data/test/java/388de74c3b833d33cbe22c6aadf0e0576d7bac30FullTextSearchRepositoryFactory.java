package by.balon.newsmaster.config.repository;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.repository.core.RepositoryMetadata;

import javax.persistence.EntityManager;

public class FullTextSearchRepositoryFactory extends JpaRepositoryFactory {
    private EntityManager entityManager;

    public FullTextSearchRepositoryFactory(EntityManager entityManager) {
        super(entityManager);
        this.entityManager = entityManager;
    }

    @Override
    protected Object getTargetRepository(RepositoryMetadata metadata) {
        //noinspection unchecked
        return isFullTextSearchRepository(metadata) ? new FullTextSearchRepositoryImpl(metadata.getDomainType(),
                entityManager) : super.getTargetRepository(metadata);
    }

    @Override
    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
        return isFullTextSearchRepository(metadata) ? FullTextSearchRepositoryImpl.class
                : super.getRepositoryBaseClass(metadata);
    }

    private boolean isFullTextSearchRepository(RepositoryMetadata metadata) {
        return FullTextSearchRepository.class.isAssignableFrom(metadata.getRepositoryInterface());
    }
}
