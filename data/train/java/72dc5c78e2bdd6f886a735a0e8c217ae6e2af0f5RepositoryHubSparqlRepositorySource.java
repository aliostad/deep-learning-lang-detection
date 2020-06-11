package org.sonatype.sisu.sparql.endpoint;

import javax.inject.Inject;

import org.openrdf.repository.Repository;
import org.sonatype.sisu.rdf.RepositoryHub;
import org.sonatype.sisu.rdf.RepositoryIdentity;

public class RepositoryHubSparqlRepositorySource
    extends RequestPathSparqlRepositorySource
{

    private final RepositoryHub repositoryHub;

    @Inject
    public RepositoryHubSparqlRepositorySource( RepositoryHub repositoryHub )
    {
        this.repositoryHub = repositoryHub;
    }

    @Override
    protected Repository get( RepositoryIdentity id )
    {
        return repositoryHub.get( id );
    }
}
