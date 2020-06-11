package gov.nasa.jsc.mdrules.repository;

import java.io.File;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.sail.nativerdf.NativeStore;
import org.openrdf.sail.memory.MemoryStore;
import org.openrdf.sail.inferencer.fc.ForwardChainingRDFSInferencer;

import gov.nasa.jsc.mdrules.util.Util;

/**
 * Implements a factory for producing sesame repositories, thereby avoiding
 * hard wiring of the type of sesame repository being used.
 * @author Sidney Bailin
 *
 */
public class SesameRepositoryFactory {
	
	public enum RepositoryType {
		NATIVE,
		NATIVE_WITH_INFERENCER,
		MEMORY,
		MEMORY_WITH_INFERENCER		
	}

	public Repository getRepository(RepositoryType type, String path) {
		switch (type) {
		case NATIVE:
			return createNativeRepository(path);
		case NATIVE_WITH_INFERENCER:
			return createNativeRepositoryWithInferencer(path);
		case MEMORY:
			return createMemoryRepository(path);
		case MEMORY_WITH_INFERENCER:
			return createMemoryRepositoryWithInferencer(path);
		default:
			throw new IllegalArgumentException("Unrecognized repository type: " + type);
		}
	}

	private Repository createNativeRepository(String path) {

		File dataDir = new File(path);
		Repository myRepository = new SailRepository(new NativeStore(dataDir));
		try {
			myRepository.initialize();
		}
		catch (RepositoryException e) {
			Util.logException(e,  this.getClass());
		}
		return myRepository;
	}
	
	private Repository createNativeRepositoryWithInferencer(String path) {

		File dataDir = new File(path);
		Repository myRepository = new SailRepository(
									new ForwardChainingRDFSInferencer(
										new NativeStore(dataDir)));
		try {
			myRepository.initialize();
		}
		catch (RepositoryException e) {
			Util.logException(e,  this.getClass());
		}
		return myRepository;
	}
	
	private Repository createMemoryRepository(String path) {

		File dataDir = new File(path);
		Repository myRepository = new SailRepository(new MemoryStore(dataDir));
		try {
			myRepository.initialize();
		}
		catch (RepositoryException e) {
			Util.logException(e,  this.getClass());
		}
		return myRepository;
	}
	
	private Repository createMemoryRepositoryWithInferencer(String path) {

		File dataDir = new File(path);
		Repository myRepository = new SailRepository(
		                          	new ForwardChainingRDFSInferencer(
		                          		new MemoryStore(dataDir)));
		try {
			myRepository.initialize();
		}
		catch (RepositoryException e) {
			Util.logException(e,  this.getClass());
		}
		return myRepository;
	}
}
