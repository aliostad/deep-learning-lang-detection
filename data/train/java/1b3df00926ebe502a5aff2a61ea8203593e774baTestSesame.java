package net.metadata.openannotation.sesame;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.repository.sail.SailRepositoryConnection;
import org.openrdf.sail.nativerdf.NativeStore;

public class TestSesame {
	
	@Rule
	public TemporaryFolder folder = new TemporaryFolder();
	
	@Test
	public void simpleSesameTest() throws RepositoryException  {
		
		SailRepository myRepository = new SailRepository(new NativeStore(folder.getRoot()));
		myRepository.initialize();
		
		RepositoryConnection con = myRepository.getConnection();
		try {
			SailRepositoryConnection con2 = myRepository.getConnection();
			try {
				
			} finally {
				con2.close();
			}
		} finally {
			con.close();
		}
	}
	

	
}
