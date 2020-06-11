package cu.uci.abcd.administration.library.ui.controller;

import java.util.Map;

import cu.uci.abcd.administration.library.ICoinService;
import cu.uci.abcd.administration.library.IEmailAddressService;
import cu.uci.abcd.administration.library.IFormationCourseService;
import cu.uci.abcd.administration.library.ILibraryService;
import cu.uci.abcd.administration.library.IPenaltyEquationService;
import cu.uci.abcd.administration.library.IPersonService;
import cu.uci.abcd.administration.library.IPostalAddressService;
import cu.uci.abcd.administration.library.IProviderService;
import cu.uci.abcd.administration.library.IWorkerService;
import cu.uci.abcd.administration.library.IWorkerTypeService;
import cu.uci.abos.ui.api.IViewController;

public class AllManagementLibraryViewController implements IViewController {
	
	private ILibraryService libraryService;
	private IFormationCourseService formationCourseService;
	private IPersonService personService;
	private IProviderService providerService;
	private ICoinService coinService;
	private IWorkerTypeService workerTypeService;
	private IWorkerService workerService;
	private IPenaltyEquationService penaltyEquationService;
	private IPostalAddressService postalAddressService;
	private IEmailAddressService emailAddressService;
		
	
	public ILibraryService getLibraryService() {
		return libraryService;
	}
	public void setLibraryService(ILibraryService libraryService) {
		this.libraryService = libraryService;
	}
	public IFormationCourseService getFormationCourseService() {
		return formationCourseService;
	}
	public void setFormationCourseService(
			IFormationCourseService formationCourseService) {
		this.formationCourseService = formationCourseService;
	}
	
	public IPersonService getPersonService() {
		return personService;
	}
	public void setPersonService(IPersonService personService) {
		this.personService = personService;
	}
	
	public IProviderService getProviderService() {
		return providerService;
	}
	public void setProviderService(IProviderService providerService) {
		this.providerService = providerService;
	}
	
	public ICoinService getCoinService() {
		return coinService;
	}
	public void setCoinService(ICoinService coinService) {
		this.coinService = coinService;
	}
	
	public IWorkerTypeService getWorkerTypeService() {
		return workerTypeService;
	}
	
	public void setWorkerTypeService(IWorkerTypeService workerTypeService) {
		this.workerTypeService = workerTypeService;
	}
	
	public IWorkerService getWorkerService() {
		return workerService;
	}
	
	public void setWorkerService(IWorkerService workerService) {
		this.workerService = workerService;
	}
	
	public IPenaltyEquationService getPenaltyEquationService() {
		return penaltyEquationService;
	}
	
	public void setPenaltyEquationService(IPenaltyEquationService penaltyEquationService) {
		this.penaltyEquationService = penaltyEquationService;
	}
	
	public IPostalAddressService getPostalAddressService() {
		return postalAddressService;
	}
	
	public void setPostalAddressService(IPostalAddressService postalAddressService) {
		this.postalAddressService = postalAddressService;
	}
	
	public IEmailAddressService getEmailAddressService() {
		return emailAddressService;
	}
	
	public void setEmailAddressService(IEmailAddressService emailAddressService) {
		this.emailAddressService = emailAddressService;
	}
	
	
	
	
	
	public void bindLibraryService(ILibraryService libraryService, Map<?, ?> properties) {
		this.setLibraryService(libraryService);
	}
	
	public void bindFormationCourseService(IFormationCourseService formationCourseService, Map<?, ?> properties) {
		this.setFormationCourseService(formationCourseService);
	}
	
	public void bindPersonService(IPersonService personService, Map<?, ?> properties) {
		this.setPersonService(personService);
	}
	
	public void bindProviderService(IProviderService providerService, Map<?, ?> properties) {
		this.setProviderService(providerService);
	}
	
	public void bindCoinService(ICoinService coinService, Map<?, ?> properties) {
		this.setCoinService(coinService);
	}
	
	public void bindWorkerTypeService(IWorkerTypeService workerTypeService, Map<?, ?> properties) {
		this.setWorkerTypeService(workerTypeService);
	}
	
	public void bindWorkerService(IWorkerService workerService, Map<?, ?> properties) {
		this.setWorkerService(workerService);
	}
	
	public void bindPenaltyEquationService(IPenaltyEquationService penaltyEquationService, Map<?, ?> properties) {
		this.setPenaltyEquationService(penaltyEquationService);
	}
	
	public void bindPostalAddressService(IPostalAddressService postalAddressService, Map<?, ?> properties) {
		this.setPostalAddressService(postalAddressService);
	}
	
	public void bindEmailAddressService(IEmailAddressService emailAddressService, Map<?, ?> properties) {
		this.setEmailAddressService(emailAddressService);
	}
	
	
	}
