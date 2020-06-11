package org.isatools.linkedISA.repository;

import org.openrdf.model.Graph;
import org.openrdf.model.Resource;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.config.RepositoryConfig;
import org.openrdf.repository.manager.LocalRepositoryManager;
import org.openrdf.repository.manager.RepositoryManager;

import java.io.File;

/**
 * Created by the ISATeam.
 * User: agbeltran
 * Date: 05/02/2014
 * Time: 14:11
 *
 * @author <a href="mailto:alejandra.gonzalez.beltran@gmail.com">Alejandra Gonzalez-Beltran</a>
 */
public class Test {


    public void connectToRepo() throws Exception{

        Graph graph = null;
        Resource repositoryNode = null;

        // Create a manager for local repositories
        RepositoryManager repositoryManager =
                new LocalRepositoryManager(new File("."));
        repositoryManager.initialize();

        // Create a configuration object from the configuration graph
        // and add it to the repositoryManager
        RepositoryConfig repositoryConfig =
                RepositoryConfig.create(graph, repositoryNode);
        repositoryManager.addRepositoryConfig(repositoryConfig);

        // Get the repository to use
        Repository repository = repositoryManager.getRepository("owlim");

        // Open a connection to this repository
        RepositoryConnection repositoryConnection =
                repository.getConnection();

        // ... use the repository

        // Shutdown connection, repository and manager
        repositoryConnection.close();
        repository.shutDown();
        repositoryManager.shutDown();

    }

}
