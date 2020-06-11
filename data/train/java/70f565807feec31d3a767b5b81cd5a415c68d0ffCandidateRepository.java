package org.camunda.bpm.hackdays.recommendation.github;

public class CandidateRepository {

  protected String repositoryOwner;
  protected String repositoryName;
  protected String repositoryType;
  
  public CandidateRepository(String repositoryOwner, String repositoryName, String repositoryType) {
    this.repositoryOwner = repositoryOwner;
    this.repositoryName = repositoryName;
    this.repositoryType = repositoryType;
  }
  public String getRepositoryOwner() {
    return repositoryOwner;
  }
  public void setRepositoryOwner(String repositoryOwner) {
    this.repositoryOwner = repositoryOwner;
  }
  public String getRepositoryName() {
    return repositoryName;
  }
  public void setRepositoryName(String repositoryName) {
    this.repositoryName = repositoryName;
  }
  public String getRepositoryType() {
    return repositoryType;
  }
  public void setRepositoryType(String repositoryType) {
    this.repositoryType = repositoryType;
  }
}
