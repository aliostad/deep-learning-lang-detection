package br.ucam.kuabaSubsystem.repositories;

import java.util.HashMap;
import java.util.Map;

public abstract class AbstractRepositoryGateway implements RepositoryGateway {
    
	protected Map<String, KuabaRepository> repositoryMap;
        
        protected abstract KuabaRepository createRepository(String url);
	protected abstract KuabaRepository newRepository(String url);	
	
	public AbstractRepositoryGateway() {
		super();
		this.repositoryMap = new HashMap<String, KuabaRepository>();
	}
        
	public Map<String, KuabaRepository> getRepositoryMap() {
		return repositoryMap;
	}
	
	@Override
	public KuabaRepository load(String url) {
		if(this.repositoryMap.containsKey(url))
			return this.repositoryMap.get(url);
		
		this.repositoryMap.put(url, this.createRepository(url));
		return this.repositoryMap.get(url);
	}
        
	@Override
	public KuabaRepository createNewRepository(String url) {
		if(this.repositoryMap.containsKey(url))			
			return this.repositoryMap.get(url);
                
		this.repositoryMap.put(url, this.newRepository(url));
		return this.repositoryMap.get(url);		
	}

}
