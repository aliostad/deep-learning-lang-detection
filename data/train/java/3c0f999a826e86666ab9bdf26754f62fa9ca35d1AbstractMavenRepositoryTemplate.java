package org.sonatype.nexus.templates.repository.maven;

import java.io.IOException;

import org.sonatype.configuration.ConfigurationException;
import org.sonatype.nexus.proxy.maven.MavenRepository;
import org.sonatype.nexus.proxy.maven.RepositoryPolicy;
import org.sonatype.nexus.proxy.registry.ContentClass;
import org.sonatype.nexus.templates.repository.AbstractRepositoryTemplate;
import org.sonatype.nexus.templates.repository.DefaultRepositoryTemplateProvider;

public abstract class AbstractMavenRepositoryTemplate
    extends AbstractRepositoryTemplate
{
    private RepositoryPolicy repositoryPolicy;

    public AbstractMavenRepositoryTemplate( DefaultRepositoryTemplateProvider provider, String id, String description,
                                            ContentClass contentClass, Class<?> mainFacet,
                                            RepositoryPolicy repositoryPolicy )
    {
        super( provider, id, description, contentClass, mainFacet );

        setRepositoryPolicy( repositoryPolicy );
    }

    @Override
    public boolean targetFits( Object clazz )
    {
        return super.targetFits( clazz ) || clazz.equals( getRepositoryPolicy() );
    }

    public RepositoryPolicy getRepositoryPolicy()
    {
        return repositoryPolicy;
    }

    public void setRepositoryPolicy( RepositoryPolicy repositoryPolicy )
    {
        this.repositoryPolicy = repositoryPolicy;
    }

    @Override
    public MavenRepository create()
        throws ConfigurationException, IOException
    {
        MavenRepository mavenRepository = (MavenRepository) super.create();

        // huh? see initConfig classes
        if ( getRepositoryPolicy() != null )
        {
            mavenRepository.setRepositoryPolicy( getRepositoryPolicy() );
        }

        return mavenRepository;
    }
}
