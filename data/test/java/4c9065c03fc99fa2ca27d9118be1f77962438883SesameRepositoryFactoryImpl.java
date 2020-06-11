/*
 * SesameRepositoryFactory.java
 *
 * Created on January 31, 2006, 12:14 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.vle.aid.metadata;

/**
 *
 * @author wrvhage
 */
public class SesameRepositoryFactoryImpl implements RepositoryFactoryImpl {
    
    public Repository createRepository() {
        return new SesameRepository();
    }
    
    public Repository createRepository(
            String server, String repository,
            String username, String password) { 
        return new SesameRepository(server,repository,username,password); 
    }
    
    public Repository createRepository(
            String server, String repository,
            String username, String password,
            String rdf_format) { 
        return new SesameRepository(server,repository,username,password); 
    }
    
}
