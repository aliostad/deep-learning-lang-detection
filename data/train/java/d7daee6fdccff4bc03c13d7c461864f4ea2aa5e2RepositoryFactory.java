package com.cea.utils.samples.database;


import com.cea.utils.database.DefaultRepository;

/**
 * Created by Carlos on 14/07/2015.
 */

public class RepositoryFactory extends com.cea.utils.database.RepositoryFactory {

    private static Repository repositoryInstance;

    @Override
    public DefaultRepository getRepository() {
        if(repositoryInstance == null ){
            repositoryInstance = new Repository(null/*PUT APP CONTEXT HERE*/);
        }
        return repositoryInstance;
    }
}

/*DECLARE CLASS ON MANIFEST - su*/
