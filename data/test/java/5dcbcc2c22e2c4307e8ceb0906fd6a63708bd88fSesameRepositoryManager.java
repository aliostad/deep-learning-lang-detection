package linkedstars.dataaccess.repository;

import java.io.IOException;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.config.RepositoryConfigException;
import org.openrdf.repository.manager.RemoteRepositoryManager;

public class SesameRepositoryManager extends RemoteRepositoryManager
{
	public SesameRepositoryManager(String serverURL)
    {
        super(serverURL);
    }

    public Repository createRepository(String id) throws RepositoryConfigException, RepositoryException 
    {
        Repository myRepository = super.createRepository(id);
        return myRepository;
    }
    
    public boolean removeRepository(String repositoryID) throws RepositoryException, RepositoryConfigException 
    {
        boolean status = super.removeRepository(repositoryID);
        return status;
    }
    
    public void cleanUpRepository(String repositoryID) throws IOException
    {
        super.cleanUpRepository(repositoryID);
    }
}
