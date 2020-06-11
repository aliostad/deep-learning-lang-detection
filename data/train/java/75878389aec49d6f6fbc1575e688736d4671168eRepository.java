package pl.mefiu.bank;

import java.util.List;

public class Repository<T> implements IRepository<T> {

    private RepositoryImpl repositoryImpl;

    public List<T> read(String query, Object[] params) {
        return repositoryImpl.read(query, params);
    }

    public void update(T entity) {
        repositoryImpl.update(entity);
    }

    public void delete(T entity) {
        repositoryImpl.delete(entity);
    }

    public void setRepositoryImpl(RepositoryImpl repositoryImpl) {
        this.repositoryImpl = repositoryImpl;
    }

}
