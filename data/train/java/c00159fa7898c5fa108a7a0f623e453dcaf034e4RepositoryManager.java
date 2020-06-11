package storage;

public class RepositoryManager {
	
	public static RepositoryManager instance;
	private static LocalPersistentRepository localPersistentRepo;
	private static Repository defaultRepository;
	
	public RepositoryManager() {
		instance = this;
		localPersistentRepo = new LocalPersistentRepository();
	}
	
	public static Repository getDefaultRepository() {
		return defaultRepository;
	}

	public LocalPersistentRepository getDefaultLocalRepository() {
		return localPersistentRepo;
	}
	
	

}
