/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package wwwc.nees.joint.module.kao;

import org.openrdf.repository.Repository;

/**
 *  Interface representing a Repository Configuration which
 * can creates a new Sesame Repository
 *
 * @author Olavo Holanda
 * @version 1.0 - 20/09/2014
 */
public interface RepositoryConfig {

    // METHODS -----------------------------------------------------------------
    /**
     * Creates a new Sesame Repository
     *
     * @return config
     *            the Repository object
     */
    public Repository createNewRepository();
}
