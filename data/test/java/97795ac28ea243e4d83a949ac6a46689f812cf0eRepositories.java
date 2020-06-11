package org.beatific.harmony.sso.repository;

import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.beatific.harmony.sso.repository.trigger.Trigger;
import org.beatific.harmony.sso.session.Session;

public class Repositories
{

	private Map<RepositoryKinds, Repository> repositories;
	private Trigger trigger;
	
	public Repositories() {
		RepositoriesFactory.setInstance(this);
		trigger = new Trigger();
	}
	
    public void setRepositories(Map<RepositoryKinds, Repository> repositories)
    {
        this.repositories = repositories;
        trigger.setRepositories(repositories);
    }
    
    public void setRelations(Properties relations)
    {
        trigger.setRelations(relations);
    }
    
    public void add(Session session) {
    	
    	Repository repository = null;
        Iterator<Entry<RepositoryKinds, Repository>> itr = repositories.entrySet().iterator();
        do
        {
        	repository = (Repository)itr.next().getValue();
            repository.add(session, trigger);
        } while(itr.hasNext());
    }
    
    public Object get(RepositoryKinds kind, String key) {
    	return repositories.get(kind).get(key);
    }
    
    public void remove(Session session) {
    	
    	Repository repository = null;
    	Iterator<Entry<RepositoryKinds, Repository>> itr = repositories.entrySet().iterator();
        do
        {
        	repository = (Repository)itr.next().getValue();
            repository.remove(session, trigger);
        } while(itr.hasNext());
    }
    
    public void evict(Session session) {
    	
    	Repository repository = null;
    	Iterator<Entry<RepositoryKinds, Repository>> itr = repositories.entrySet().iterator();
        do
        {
        	repository = (Repository)itr.next().getValue();
            repository.evict(session, trigger);
        } while(itr.hasNext());
    }
    
    public void addRepository(Session session) {
    	Repository repository = null;
    	Iterator<Entry<RepositoryKinds, Repository>> itr = repositories.entrySet().iterator();
        do
        {
        	repository = (Repository)itr.next().getValue();
            repository.addRepository(session);
        } while(itr.hasNext());
    }
    
    public void removeRepository(Session session) {
    	Repository repository = null;
    	Iterator<Entry<RepositoryKinds, Repository>> itr = repositories.entrySet().iterator();
        do
        {
        	repository = (Repository)itr.next().getValue();
            repository.removeRepository(session);
        } while(itr.hasNext());
    }

}