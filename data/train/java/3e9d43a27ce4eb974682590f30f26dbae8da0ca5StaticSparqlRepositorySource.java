package org.sonatype.sisu.sparql.endpoint;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;

import org.openrdf.repository.Repository;

public class StaticSparqlRepositorySource
    implements SparqlRepositorySource
{

    private final Repository repository;

    @Inject
    public StaticSparqlRepositorySource( @Named( "${repository}" ) Repository repository )
    {
        this.repository = repository;
    }

    @Override
    public Repository repositoryFor( HttpServletRequest request )
    {
        return repository;
    }

}
