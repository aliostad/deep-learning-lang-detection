package org.trippi.impl.sesame;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.trippi.AliasManager;

public class SesameSession extends AbstractSesameSession {

    public SesameSession(Repository repository, String serverUri, String model) throws RepositoryException {
        super(repository, serverUri, model);
        // TODO Auto-generated constructor stub
    }

    public SesameSession(Repository repository, AliasManager aliasManager, String serverUri, String model)
            throws RepositoryException {
        super(repository, aliasManager, serverUri, model);
        // TODO Auto-generated constructor stub
    }

}
