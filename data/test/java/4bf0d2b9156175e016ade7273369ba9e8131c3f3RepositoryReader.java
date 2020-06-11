/**
 * Copyright (C) 2011-2012 Tim Besard <tim.besard@gmail.com>
 *
 * All rights reserved.
 */
package be.mira.codri.server.bo.repository;

import be.mira.codri.server.bo.Repository;
import be.mira.codri.server.exceptions.RepositoryException;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author tim
 */
public abstract class RepositoryReader {
    //
    // Member data
    //
    
    private final Repository mRepository;
    
    
    //
    // Construction and destruction
    //
    
    @Autowired
    public RepositoryReader(final Repository iRepository) {
        mRepository = iRepository;        
    }
    
    
    //
    // Basic I/O
    //
    
    final protected Repository getRepository() {
        return mRepository;
    }
    
    
    //
    // Interface
    //
    
    public abstract void checkout() throws RepositoryException;
    
    public abstract void update() throws RepositoryException;
    
}
