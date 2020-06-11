package org.pentaho.pac.common.config;

import java.io.Serializable;

public class PdiConfig implements IPdiConfig, Serializable {

  String repositoryName;
  String repositoryType;
  String repositoryUserId;
  String repositoryPassword;
  String repositoryXmlFile;
  
  public PdiConfig() {
    
  }
  
  public PdiConfig(IPdiConfig pdiConfig) {
    setRepositoryName(pdiConfig.getRepositoryName());
    setRepositoryPassword(pdiConfig.getRepositoryPassword());
    setRepositoryType(pdiConfig.getRepositoryType());
    setRepositoryUserId(pdiConfig.getRepositoryUserId());
    setRepositoryXmlFile(pdiConfig.getRepositoryXmlFile());
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
  public String getRepositoryUserId() {
    return repositoryUserId;
  }
  public void setRepositoryUserId(String repositoryUserId) {
    this.repositoryUserId = repositoryUserId;
  }
  public String getRepositoryXmlFile() {
    return repositoryXmlFile;
  }
  public void setRepositoryXmlFile(String repositoryXmlFile) {
    this.repositoryXmlFile = repositoryXmlFile;
  }
  public String getRepositoryPassword() {
    return repositoryPassword;
  }
  public void setRepositoryPassword(String repositoryPassword) {
    this.repositoryPassword = repositoryPassword;
  }
  
  
}
