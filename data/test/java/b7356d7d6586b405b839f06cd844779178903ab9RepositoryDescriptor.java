package net.codjo.dataprocess.server.treatmenthelper;
/**
 *
 */
public class RepositoryDescriptor {
    private int repositoryId;
    private String repositoryName;
    private String[] repositoryPath;


    public RepositoryDescriptor(int repositoryId, String repositoryName, String[] repositoryPath) {
        this.repositoryId = repositoryId;
        this.repositoryName = repositoryName;
        this.repositoryPath = repositoryPath;
    }


    public int getRepositoryId() {
        return repositoryId;
    }


    public String getRepositoryName() {
        return repositoryName;
    }


    public String[] getRepositoryPath() {
        return repositoryPath;
    }
}
