package se.vgr.crawler.service;

import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.config.RepositoryConfigException;

import se.vgr.crawler.AbstractDataAccess;
import se.vgr.crawler.repository.RepositoryManager;

/**
 * <p>Test case: Repository manager</p>
 * @author Johan Säll Larsson
 */

public class HarvesterRepositoryTest extends AbstractDataAccess {

	private RepositoryManager repositoryManager;
	
	@Override
	protected void onSetUp() throws Exception {
		super.onSetUp();
		repositoryManager = (RepositoryManager) applicationContext.getBean("repositoryManager");
	}
	
	public void testCreateRepository() throws RepositoryException, RepositoryConfigException{
		
		repositoryManager.addRepository("TEST");
		repositoryManager.getRepository("TEST");
		
	}
	
}
