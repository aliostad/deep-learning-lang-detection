package org.donnchadh.gaelbot.domainmodel;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;

import org.donnchadh.gaelbot.domainmodel.servicelocator.FactoryRegistry;

@Entity
public class RepositoryDocument {
    @Id
    @GeneratedValue
    private Long id;
    
    @Transient
    private DocumentRepository repository;
    
    private long fileId;
    
    public RepositoryDocument(DocumentRepository repository, long fileId) {
        this.repository = repository;
        this.fileId = fileId;
    }
    
    public byte[] getContent() {
        return repository.getContent(fileId);
    }
    
    
    public void setRepositoryPath(String path) {
        repository = FactoryRegistry.getInstance().getDocumentRepositoryFactory().getDocumentRepository(path);
    }
    
    public String getRepositoryPath() {
        return repository.getRepositoryPath();
    }
}
