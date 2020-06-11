package uk.co.revsys.resource.repository.webapp;

import uk.co.revsys.resource.repository.ResourceRepository;
import uk.co.revsys.resource.repository.ResourceRepositoryBuilder;

public class WebappResourceRepositoryBuilder implements ResourceRepositoryBuilder{

    private String repositoryBase;

    public WebappResourceRepositoryBuilder(String repositoryBase) {
        this.repositoryBase = repositoryBase;
    }
    
    @Override
    public ResourceRepository build() {
        return new WebappResourceRepository(repositoryBase);
    }

}
