package cu.uci.abcd.circulation.ui.controller;

import java.util.Map;

import cu.uci.abcd.circulation.ILoanUserService;
import cu.uci.abcd.circulation.IPenaltyService;
import cu.uci.abcd.circulation.IPersonService;
import cu.uci.abcd.circulation.IReservationService;
import cu.uci.abcd.circulation.ITransactionService;
import cu.uci.abos.ui.api.IViewController;

public class AllManagementLoanUserViewController implements IViewController {
	
	/**
	 * 
	 * @author Yanet Crespo Diaz
	 * 
	 */
	
	private ILoanUserService manageLoanUser;
	private IPersonService personService;
	private IPenaltyService managePenalty;
	private ITransactionService manageTransaction;
	private IReservationService manageReservation;
	
	public IPenaltyService getManagePenalty() {
		return managePenalty;
	}
	public void setManagePenalty(IPenaltyService managePenalty) {
		this.managePenalty = managePenalty;
	}
	public ILoanUserService getManageLoanUser() {
		return manageLoanUser;
	}
	public void setManageLoanUser(ILoanUserService manageLoanUser) {
		this.manageLoanUser = manageLoanUser;
	}

	public IPersonService getPersonService() {
		return personService;
	}
	public void setPersonService(IPersonService personService) {
		this.personService = personService;
	}
	public ITransactionService getManageTransaction() {
		return manageTransaction;
	}
	public void setManageTransaction(ITransactionService manageTransaction) {
		this.manageTransaction = manageTransaction;
	}
	public IReservationService getManageReservation() {
		return manageReservation;
	}
	public void setManageReservation(IReservationService manageReservation) {
		this.manageReservation = manageReservation;
	}
	public void bindManageLoanUser(ILoanUserService manageLoanUser, Map<?, ?> properties) {
		this.setManageLoanUser(manageLoanUser);
	}

	public void bindManagePenalty(IPenaltyService managePenalty, Map<?, ?> properties) {
		this.setManagePenalty(managePenalty);
	}
	
	public void bindPersonService(IPersonService personService, Map<?, ?> properties) {
		this.setPersonService(personService);
	}

	public void bindTransactionService(ITransactionService manageTransaction, Map<?, ?> properties) {
		this.setManageTransaction(manageTransaction);
	}
	
	public void bindReservationService(IReservationService manageReservation, Map<?, ?> properties) {
		this.setManageReservation(manageReservation);
	}
	
	
}
