package uk.co.revsys.resource.repository.classpath;

import uk.co.revsys.resource.repository.ResourceRepository;
import uk.co.revsys.resource.repository.ResourceRepositoryBuilder;

public class ClasspathResourceRepositoryBuilder implements ResourceRepositoryBuilder{

    private String repositoryBase;

    public ClasspathResourceRepositoryBuilder(String repositoryBase) {
        this.repositoryBase = repositoryBase;
    }
    
    @Override
    public ResourceRepository build() {
        return new ClasspathResourceRepository(repositoryBase);
    }

}
