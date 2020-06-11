package neo.app.service;

public class ServiceManager {
	private UserService userService;
	private HomePageService homePageService;
	private AboutService aboutService;
	private KnowledgeService knowledgeService;
	private PrimaryService primaryService;
	private MethodService methodService;
	private ExperienceService experienceService;
	private DataService dataService;
	private JuniorService juniorService;

	private FrontService frontService;

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public HomePageService getHomePageService() {
		return homePageService;
	}

	public void setHomePageService(HomePageService homePageService) {
		this.homePageService = homePageService;
	}

	public FrontService getFrontService() {
		return frontService;
	}

	public void setFrontService(FrontService frontService) {
		this.frontService = frontService;
	}

	public AboutService getAboutService() {
		return aboutService;
	}

	public void setAboutService(AboutService aboutService) {
		this.aboutService = aboutService;
	}

	public KnowledgeService getKnowledgeService() {
		return knowledgeService;
	}

	public void setKnowledgeService(KnowledgeService knowledgeService) {
		this.knowledgeService = knowledgeService;
	}

	public PrimaryService getPrimaryService() {
		return primaryService;
	}

	public void setPrimaryService(PrimaryService primaryService) {
		this.primaryService = primaryService;
	}

	public MethodService getMethodService() {
		return methodService;
	}

	public void setMethodService(MethodService methodService) {
		this.methodService = methodService;
	}

	public ExperienceService getExperienceService() {
		return experienceService;
	}

	public void setExperienceService(ExperienceService experienceService) {
		this.experienceService = experienceService;
	}

	public DataService getDataService() {
		return dataService;
	}

	public void setDataService(DataService dataService) {
		this.dataService = dataService;
	}

	public JuniorService getJuniorService() {
		return juniorService;
	}

	public void setJuniorService(JuniorService juniorService) {
		this.juniorService = juniorService;
	}

}