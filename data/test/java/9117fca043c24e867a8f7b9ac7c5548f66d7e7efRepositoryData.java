package de.dini.oanetzwerk.utils.imf;

import java.math.BigDecimal;

public class RepositoryData {
	
	BigDecimal referToOID;
	int repositoryID; 
	String repositoryName;
	String repositoryURL;
	String repositoryOAI_BASEURL;
	String repositoryOAI_EXTID;	
	
	public RepositoryData() {
		
	}
	
    public RepositoryData(BigDecimal referToOID) {
    	this.referToOID = referToOID;
	}

	public String toString() {
		StringBuffer sbResult = new StringBuffer();
		sbResult.append("referToOID=" + this.referToOID)
		        .append("\n  repositoryID=" + this.repositoryID)
		        .append("\n  repositoryName=" + this.repositoryName)
		        .append("\n  repositoryURL=" + this.repositoryURL)
		        .append("\n  repositoryOAI_BASEURL=" + this.repositoryOAI_BASEURL)
		        .append("\n  repositoryOAI_EXTID=" + this.repositoryOAI_EXTID);
		return sbResult.toString();
	}
    
	public BigDecimal getReferToOID() {
		return referToOID;
	}

	public void setReferToOID(BigDecimal referToOID) {
		this.referToOID = referToOID;
	}

	public int getRepositoryID() {
		return repositoryID;
	}

	public void setRepositoryID(int repositoryID) {
		this.repositoryID = repositoryID;
	}

	public String getRepositoryName() {
		return repositoryName;
	}

	public void setRepositoryName(String repositoryName) {
		this.repositoryName = repositoryName;
	}

	public String getRepositoryURL() {
		return repositoryURL;
	}

	public void setRepositoryURL(String repositoryURL) {
		this.repositoryURL = repositoryURL;
	}

	public String getRepositoryOAI_BASEURL() {
		return repositoryOAI_BASEURL;
	}

	public void setRepositoryOAI_BASEURL(String repositoryOAI_BASEURL) {
		this.repositoryOAI_BASEURL = repositoryOAI_BASEURL;
	}

	public String getRepositoryOAI_EXTID() {
		return repositoryOAI_EXTID;
	}

	public void setRepositoryOAI_EXTID(String repositoryOAI_EXTID) {
		this.repositoryOAI_EXTID = repositoryOAI_EXTID;
	}
    
}
