/**
 * 
 */
package jp.dip.sys1.yagi.atm.repository;

/**
 * Templates info.
 * 
 * @author yagitoshihiro
 * 
 */
public class Repository {
    private String mRepositoryId = null;
    private String mRepositoryName = null;
    private String mRepositoryURL = null;

    // private String mVersion = null;
    // TODO description?

    public Repository(String mRepositoryId, String repositoryName, String repositoryURL) {
        this.mRepositoryId = mRepositoryId;
        this.mRepositoryName = repositoryName;
        this.mRepositoryURL = repositoryURL;
    }

    public String getRepositoryId() {
        return mRepositoryId;
    }

    public String getRepositoryURL() {
        return mRepositoryURL;
    }

    public String getRepositoryName() {
        return mRepositoryName;
    }

    @Override
    public String toString() {

        String name = mRepositoryName;
        if (name == null) {
            name = mRepositoryId;
        }

        return name + "(id=" + mRepositoryId + ") : " + mRepositoryURL;
    }
}
