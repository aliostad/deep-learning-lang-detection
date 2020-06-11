package uma.caosd.AspectualKnowledge.DynamicAspects;


public class DynamicRepository {
	private AdvisorsRepository advisorRepository;
	private UsersAdvisorsRepository userAdvisorsRepository;
	private AdvisorsRepository advisorRepositoryDISABLED;
	private UsersAdvisorsRepository userAdvisorsRepositoryDISABLED; 
	
	public DynamicRepository() {
		advisorRepository = new AdvisorsRepository();
		userAdvisorsRepository = new UsersAdvisorsRepository();
		
		advisorRepositoryDISABLED = new AdvisorsRepository();
		userAdvisorsRepositoryDISABLED = new UsersAdvisorsRepository();
	}
	
	public DynamicRepository(AdvisorsRepository advisorRepository, UsersAdvisorsRepository userAdvisorsRepository, AdvisorsRepository advisorRepositoryDISABLED, UsersAdvisorsRepository userAdvisorsRepositoryDISABLED) {
		this.advisorRepository = advisorRepository;
		this.userAdvisorsRepository = userAdvisorsRepository;
		
		this.advisorRepositoryDISABLED = advisorRepositoryDISABLED;
		this.userAdvisorsRepositoryDISABLED = userAdvisorsRepositoryDISABLED;
	}

	public AdvisorsRepository getAdvisorRepository() {
		return advisorRepository;
	}

	public void setAdvisorRepository(AdvisorsRepository advisorRepository) {
		this.advisorRepository = advisorRepository;
	}

	public UsersAdvisorsRepository getUserAdvisorsRepository() {
		return userAdvisorsRepository;
	}

	public void setUserAdvisorsRepository(UsersAdvisorsRepository userAdvisorsRepository) {
		this.userAdvisorsRepository = userAdvisorsRepository;
	}

	public AdvisorsRepository getAdvisorRepositoryDISABLED() {
		return advisorRepositoryDISABLED;
	}

	public void setAdvisorRepositoryDISABLED(
			AdvisorsRepository advisorRepositoryDISABLED) {
		this.advisorRepositoryDISABLED = advisorRepositoryDISABLED;
	}

	public UsersAdvisorsRepository getUserAdvisorsRepositoryDISABLED() {
		return userAdvisorsRepositoryDISABLED;
	}

	public void setUserAdvisorsRepositoryDISABLED(
			UsersAdvisorsRepository userAdvisorsRepositoryDISABLED) {
		this.userAdvisorsRepositoryDISABLED = userAdvisorsRepositoryDISABLED;
	}
	
}
