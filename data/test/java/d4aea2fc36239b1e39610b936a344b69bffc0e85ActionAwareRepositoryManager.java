package org.duguo.xdir.jcr.factory;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.RepositoryFactory;
import java.util.Map;


public class ActionAwareRepositoryManager implements RepositoryFactory
{
    
    private static final Logger logger = LoggerFactory.getLogger( ActionAwareRepositoryManager.class );


    private Map<String, RepositoryAction> repositoryActions;
    private String defaultAction="repositoryLoad";
    

    @SuppressWarnings("unchecked")
    public Repository getRepository( Map parameters ) throws RepositoryException
    {
        Repository repository=null; 
        try
        {
            String actionName=(String)parameters.get( "action" );
            if(actionName==null){
                actionName=defaultAction;
            }
            
            repository = performAction( parameters, actionName );
        }
        catch ( RepositoryException ex )
        {
            throw ex;
        }
        catch ( RuntimeException ex )
        {
            throw ex;
        }
        catch ( Exception ex )
        {
            throw new RepositoryException("failed to get repository",ex);
        }
        return repository;
    }


    @SuppressWarnings("unchecked")
    protected synchronized Repository  performAction( Map parameters, String actionName )throws Exception
    {
        Repository repository=null;
        RepositoryAction repositoryAction=repositoryActions.get( actionName );
        if(repositoryAction==null){
            throw new RepositoryException("repository action ["+actionName+"] not found");
        }else{
            repository=repositoryAction.execute( parameters );
            if(logger.isDebugEnabled())
                logger.debug("repository action [{}] finished",actionName);
        }
        return repository;
    }


    public void setRepositoryActions( Map<String, RepositoryAction> repositoryActions )
    {
        this.repositoryActions = repositoryActions;
    }


    public void setDefaultAction( String defaultAction )
    {
        this.defaultAction = defaultAction;
    }

}
