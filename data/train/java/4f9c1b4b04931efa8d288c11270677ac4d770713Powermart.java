package net.orangemile.informatica.powercenter.domain;

import java.util.ArrayList;

public class Powermart implements Cloneable {

	private String creationDate;
	private String repositoryVersion;
	private ArrayList<Repository> repositoryList;
	
	public String getCreationDate() {
		return creationDate;
	}
	public void setCreationDate(String creationDate) {
		this.creationDate = creationDate;
	}
	public String getRepositoryVersion() {
		return repositoryVersion;
	}
	public void setRepositoryVersion(String repositoryVersion) {
		this.repositoryVersion = repositoryVersion;
	}
	public ArrayList<Repository> getRepositoryList() {
		return repositoryList;
	}
	public void setRepositoryList(ArrayList<Repository> repositoryList) {
		this.repositoryList = repositoryList;
	}	
	
	public void addRepository( Repository rep ) {
		if ( repositoryList == null ) {
			repositoryList = new ArrayList<Repository>();
		}
		repositoryList.add(rep);
	}
	
	@Override
	public Object clone() {
		try {
			return super.clone();
		} catch ( CloneNotSupportedException e ) {
			throw new RuntimeException(e);
		}
	}	
}
