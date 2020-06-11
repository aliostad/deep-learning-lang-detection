package org.sonatype.sisu.rdf;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;

public interface RepositoryHub
{

    Repository add( RepositoryIdentity id );

    Repository add( RepositoryIdentity id, RepositoryFactory repositoryFactory );

    void delete( RepositoryIdentity id );

    void shutdown( RepositoryIdentity id );

    void shutdown();

    Repository get( RepositoryIdentity id );

    public static interface RepositoryFactory
    {

        Repository create( RepositoryIdentity id )
            throws RepositoryException;

    }
}
