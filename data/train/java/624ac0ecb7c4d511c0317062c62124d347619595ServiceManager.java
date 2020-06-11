package projet.epf.jee.service.manager;
/**
 * 
 * @author Cecile Dreyfus
 * @author Emilie Durand
 *
 */
import projet.epf.jee.service.CompanyService;
import projet.epf.jee.service.ComputerService;
import projet.epf.jee.service.impl.CompanyServiceImpl;
import projet.epf.jee.service.impl.ComputerServiceImpl;

public enum ServiceManager {
	
	INSTANCE;
	
	/**
	 * @see CompanyService
	 * @see ComputerService
	 */
	private CompanyService companyService;
	private ComputerService computerService;
	
	private ServiceManager(){
		computerService = new ComputerServiceImpl();
		companyService = new CompanyServiceImpl();
	}
	
	public ComputerService getComputerService(){
		return computerService;
	}
	
	public CompanyService getCompanyService(){
		return companyService;
	}

}
