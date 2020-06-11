package org.stringtree.fetcher;

import org.stringtree.Repository;

public class DelegatedRepository extends DelegatedFetcher implements Repository {

    public DelegatedRepository(Repository other) {
        super(other);
    }

    protected DelegatedRepository() {
        super(null);
    }

    protected Repository realRepository() {
        return (Repository)realFetcher();
    }
    
    public void clear() {
        realRepository().clear();
    }

    public void lock() {
        realRepository().lock();
    }
    
    public boolean isLocked() {
        return realRepository().isLocked();
    }

    public void put(String name, Object value) {
        realRepository().put(name, value);
    }

    public void remove(String name) {
        realRepository().remove(name);
    }
}
