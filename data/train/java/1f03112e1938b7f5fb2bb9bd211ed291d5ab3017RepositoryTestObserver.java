/**
 * 
 */
package com.ecollege.lunit.event;

import org.apache.log4j.Logger;

import com.ecollege.lunit.repository.EventRepository;
import com.ecollege.lunit.repository.RepositoryException;


/**
 * @author toddf
 *
 */
public class RepositoryTestObserver
implements TestObserver
{
	// SECTION: CONSTANTS
	
    protected static final Logger LOG = Logger.getLogger(RepositoryTestObserver.class);
    
    
    // SECTION: INSTANCE VARIABLES
    
    private EventRepository repository;


    // SECTION: ACCESSORS/MUTATORS
    
	public EventRepository getRepository()
	{
		return repository;
	}

	public void setRepository(EventRepository repository)
	{
		this.repository = repository;
	}


	// SECTION: TEST OBSERVER

	@Override
	public void notify(TestEvent event)
	{
		try
		{
			repository.insert(event);
		}
		catch (RepositoryException e)
		{
			LOG.error(e);
		}
	}
}
