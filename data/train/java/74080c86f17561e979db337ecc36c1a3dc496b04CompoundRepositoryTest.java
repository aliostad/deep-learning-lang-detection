/*
 * Created on Dec 14, 2004
 */
package org.openedit.repository;

import java.io.File;
import java.util.Arrays;
import java.util.List;

import org.openedit.repository.filesystem.BaseRepositoryTest;
import org.openedit.repository.filesystem.FileItem;
import org.openedit.repository.filesystem.FileRepository;

import com.openedit.BaseTestCase;


/**
 * @author Matthew Avery, mavery@einnovation.com
 */
public class CompoundRepositoryTest extends BaseTestCase
{
	public CompoundRepositoryTest( String inName )
	{
		super( inName );
	}
	
	protected Repository createRepository() throws Exception
	{
		CompoundRepository repository = new CompoundRepository();
		BaseRepositoryTest test = new BaseRepositoryTest( "blah");
		test.makeIndexFile();
		repository.setDefaultRepository( test.getRepository() );
		FileRepository repos = new FileRepository("/openedit/test/", new File( getRoot(),"/openedit/test") );
		repository.addRepository(repos);
		return repository;
	}
	
	public void testGet() throws Exception
	{
		Repository repository = createRepository();
		ContentItem index = repository.get( "/index.html" );
		assertTrue(index instanceof FileItem );
	}

	public void testMountPoint() throws Exception
	{
		CompoundRepository repository = new CompoundRepository();
		FileRepository stuff = new FileRepository("/stuff", new File( getRoot(), "/stuff"))
		{
			public List getChildrenNames(String inParent) throws RepositoryException
			{
				return Arrays.asList(new String[]{"larry","moe"});
			}
		};
		repository.addRepository(stuff );
		//Default one is set to null
		assertNotNull(repository.resolveRepository("/stuff"));
		List children = repository.getChildrenNames("/stuff");
		assertEquals( 2,children.size());
	}


}
