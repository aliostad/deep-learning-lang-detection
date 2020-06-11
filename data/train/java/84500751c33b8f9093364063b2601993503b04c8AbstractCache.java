package org.gmock.sample;

public abstract class AbstractCache implements Cache {

    protected Repository repository;

    protected AbstractCache(Repository repository) {
        this.repository = repository;
    }

    public Repository getUnderlyingRepository() {
        return repository;
    }

    public Object get(String key) throws NotFoundException {
        Object value = getFromCache(key);
        if (null == value) {
            value = repository.get(key);
            putToCache(key, value);
        }
        return value;
    }

}
