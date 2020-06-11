/**
 * 
 */
package com.github.sesameloader.repository;

import org.openrdf.model.ValueFactory;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.sail.SailException;

import com.github.sesameloader.RepositoryManager;

/**
 * @author Peter Ansell p_ansell@yahoo.com
 *
 */
public class ArbitraryRepositoryManager implements RepositoryManager
{
    
    private Repository upstreamRepository;

    /**
     * Constructs an ArbitraryRepositoryManager as a wrapper around any repository
     */
    public ArbitraryRepositoryManager(Repository upstreamRepository)
    {
        this.upstreamRepository = upstreamRepository;
    }
    
    /* (non-Javadoc)
     * @see com.github.sesameloader.RepositoryManager#getConnection()
     */
    @Override
    public RepositoryConnection getConnection() throws RepositoryException
    {
        return upstreamRepository.getConnection();
    }
    
    /* (non-Javadoc)
     * @see com.github.sesameloader.RepositoryManager#shutDown()
     */
    @Override
    public void shutDown() throws SailException, RepositoryException
    {
        this.upstreamRepository.shutDown();
    }
    
    /* (non-Javadoc)
     * @see com.github.sesameloader.RepositoryManager#getValueFactory()
     */
    @Override
    public ValueFactory getValueFactory()
    {
        return this.upstreamRepository.getValueFactory();
    }

    @Override
    public Integer getMaximumThreads()
    {
        return 0;
    }
    
}
