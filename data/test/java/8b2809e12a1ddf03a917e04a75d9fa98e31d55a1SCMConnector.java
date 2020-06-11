package br.ufrn.ppgsc.fc.connectors;


public abstract class SCMConnector {
	
	protected String repositoryLocalPath;
	protected String repositoryName;
	
	public abstract void performSetup();	

	// Gets e Sets

	public String getRepositoryLocalPath() {
		return repositoryLocalPath;
	}

	public void setRepositoryLocalPath(String repositoryLocalPath) {
		this.repositoryLocalPath = repositoryLocalPath;
	}

	public String getRepositoryName() {
		return repositoryName;
	}

	public void setRepositoryName(String repositoryName) {
		this.repositoryName = repositoryName;
	}

}
