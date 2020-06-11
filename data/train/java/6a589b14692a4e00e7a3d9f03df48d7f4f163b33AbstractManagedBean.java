package com.conflux.web;

import java.io.Serializable;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedProperty;
import javax.faces.context.FacesContext;

import com.conflux.service.IAssetTypeService;
import com.conflux.service.IAuditService;
import com.conflux.service.IAuditTypeService;
import com.conflux.service.IBaseService;
import com.conflux.service.ICustomerService;
import com.conflux.service.IEmployeeService;
import com.conflux.service.ILoanService;
import com.conflux.service.IMeetingService;
import com.conflux.service.IOccupationTypeService;
import com.conflux.service.IPortalUserService;
import com.conflux.service.IRiskRatingService;

public class AbstractManagedBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2122641597484555564L;

	@ManagedProperty(value = "#{baseService}")
	private IBaseService baseService;

	@ManagedProperty(value = "#{assetTypeService}")
	private IAssetTypeService assetTypeService;

	@ManagedProperty(value = "#{auditService}")
	private IAuditService auditService;

	@ManagedProperty(value = "#{auditTypeService}")
	private IAuditTypeService auditTypeService;

	@ManagedProperty(value = "#{customerService}")
	private ICustomerService customerService;

	@ManagedProperty(value = "#{loanService}")
	private ILoanService loanService;

	@ManagedProperty(value = "#{meetingService}")
	private IMeetingService meetingService;

	@ManagedProperty(value = "#{occupationTypeService}")
	private IOccupationTypeService occupationTypeService;

	@ManagedProperty(value = "#{employeeService}")
	private IEmployeeService employeeService;

	@ManagedProperty(value = "#{portalUserService}")
	private IPortalUserService userService;
	
	@ManagedProperty(value = "#{riskRatingService}")
	private IRiskRatingService riskRatingService;

	@ManagedProperty(value = "#{loginBean}")
	private LoginManagedBean loginBean;

	public void addFacesError(String errorMessage) {
		FacesContext.getCurrentInstance().addMessage(
				null,
				new FacesMessage(FacesMessage.SEVERITY_ERROR, errorMessage,
						errorMessage));
	}

	public void addFacesWarning(String warningMessage) {
		FacesContext.getCurrentInstance().addMessage(
				null,
				new FacesMessage(FacesMessage.SEVERITY_WARN, warningMessage,
						warningMessage));
	}

	public void addFacesInfo(String infoMessage) {
		FacesContext.getCurrentInstance().addMessage(
				null,
				new FacesMessage(FacesMessage.SEVERITY_INFO, infoMessage,
						""));
	}

	public IBaseService getBaseService() {
		return baseService;
	}

	public void setBaseService(IBaseService baseService) {
		this.baseService = baseService;
	}

	public IAssetTypeService getAssetTypeService() {
		return assetTypeService;
	}

	public void setAssetTypeService(IAssetTypeService assetTypeService) {
		this.assetTypeService = assetTypeService;
	}

	public IAuditService getAuditService() {
		return auditService;
	}

	public void setAuditService(IAuditService auditService) {
		this.auditService = auditService;
	}

	public IAuditTypeService getAuditTypeService() {
		return auditTypeService;
	}

	public void setAuditTypeService(IAuditTypeService auditTypeService) {
		this.auditTypeService = auditTypeService;
	}

	public ICustomerService getCustomerService() {
		return customerService;
	}

	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}

	public ILoanService getLoanService() {
		return loanService;
	}

	public void setLoanService(ILoanService loanService) {
		this.loanService = loanService;
	}

	public IMeetingService getMeetingService() {
		return meetingService;
	}

	public void setMeetingService(IMeetingService meetingService) {
		this.meetingService = meetingService;
	}

	public IOccupationTypeService getOccupationTypeService() {
		return occupationTypeService;
	}

	public void setOccupationTypeService(
			IOccupationTypeService occupationTypeService) {
		this.occupationTypeService = occupationTypeService;
	}

	public LoginManagedBean getLoginBean() {
		return loginBean;
	}

	public void setLoginBean(LoginManagedBean loginBean) {
		this.loginBean = loginBean;
	}

	public IEmployeeService getEmployeeService() {
		return employeeService;
	}

	public void setEmployeeService(IEmployeeService employeeService) {
		this.employeeService = employeeService;
	}

	public IPortalUserService getUserService() {
		return userService;
	}

	public void setUserService(IPortalUserService userService) {
		this.userService = userService;
	}

	/**
	 * @return the riskRatingService
	 */
	public IRiskRatingService getRiskRatingService() {
		return riskRatingService;
	}

	/**
	 * @param riskRatingService the riskRatingService to set
	 */
	public void setRiskRatingService(IRiskRatingService riskRatingService) {
		this.riskRatingService = riskRatingService;
	}
	
	
}