package org.designpatterns.abstractfactory;

public class UserRepositoryFactory implements IUserRepositoryFactory {

    private IUserRepository databaseUserRepository;
    private IUserRepository cacheUserRepository;

    public UserRepositoryFactory(IUserRepository databaseUserRepository,
                                 IUserRepository cacheUserRepository) {
        this.databaseUserRepository = databaseUserRepository;
        this.cacheUserRepository = cacheUserRepository;
    }

    public IUserRepository create(RepositoryType repositoryType) {

        if (RepositoryType.DATABASE.equals(repositoryType)) {
            return databaseUserRepository;
        } else if (RepositoryType.CACHE.equals(repositoryType)) {
            return cacheUserRepository;
        }

        throw new IllegalArgumentException("RepositoryType not supported!");
    }
}
