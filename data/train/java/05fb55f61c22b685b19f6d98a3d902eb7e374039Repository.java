package it.infn.ct.aginfrasgmobile.pojos;

public class Repository {

	private String repository;
	private String repositoryName;
	private String thumbURL;
	
	
	
	public Repository() {
		super();
	}

	public Repository(String repository, String repositoryName,
			String thumbURL) {
		super();
		this.repository = repository;
		this.repositoryName = repositoryName;
		this.thumbURL = thumbURL;
	}

	public String getRepository() {
		return repository;
	}
	
	public void setRepository(String repository) {
		this.repository = repository;
	}
	
	public String getRepositoryName() {
		return repositoryName;
	}
	
	public void setRepositoryName(String repositoryName) {
		this.repositoryName = repositoryName;
	}
	
	public String getThumbURL() {
		return thumbURL;
	}
	
	public void setThumbURL(String thumbURL) {
		this.thumbURL = thumbURL;
	}

	@Override
	public String toString() {
		return repositoryName;
	}
		
}
