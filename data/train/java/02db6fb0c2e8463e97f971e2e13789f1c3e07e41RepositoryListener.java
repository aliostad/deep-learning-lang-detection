package se.spline.query.neo4j.repository;

import org.axonframework.eventhandling.annotation.EventHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import se.spline.api.repository.event.RepositoryCreatedEvent;
import se.spline.api.repository.event.RepositoryDeletedEvent;
import se.spline.api.repository.event.RepositoryMetaDataUpdatedEvent;
import se.spline.api.repository.event.RepositoryRootFolderChangedEvent;
import se.spline.query.neo4j.folder.FolderQueryRepository;

@Component
public class RepositoryListener {

    private final RepositoryQueryRepository repositoryQueryRepository;
    private final FolderQueryRepository folderQueryRepository;

    @Autowired
    public RepositoryListener(RepositoryQueryRepository repositoryQueryRepository, FolderQueryRepository folderQueryRepository) {
        this.repositoryQueryRepository = repositoryQueryRepository;
        this.folderQueryRepository = folderQueryRepository;
    }

    @EventHandler
    public void handleRepositoryCreatedEvent(RepositoryCreatedEvent event) {
        final RepositoryEntity entity = RepositoryEntity.builder().repositoryId(event.getId().getIdentifier()).name(event.getMetaData().getName()).build();
        repositoryQueryRepository.save(entity);
    }

    @EventHandler
    public void handleRepositoryRootFolderUpdate(RepositoryRootFolderChangedEvent event) {
        final RepositoryEntity repositoryEntity = repositoryQueryRepository.findByRepositoryId(event.getRepositoryId().getIdentifier());
        repositoryEntity.setRootFolder(folderQueryRepository.findByFolderId(event.getFolderId().getIdentifier()));
        repositoryQueryRepository.save(repositoryEntity);
    }

    @EventHandler
    public void handleRepositoryDeleted(RepositoryDeletedEvent event) {
        repositoryQueryRepository.deleteByRepositoryId(event.getId().getIdentifier());
    }

    @EventHandler
    public void handleRepositoryMetaDataUpdated(RepositoryMetaDataUpdatedEvent event) {
        final RepositoryEntity repositoryEntity = repositoryQueryRepository.findByRepositoryId(event.getId().getIdentifier());
        repositoryEntity.setName(event.getMetaData().getName());
        repositoryEntity.setDescription(event.getMetaData().getDescription());
        repositoryQueryRepository.save(repositoryEntity);
    }
}
