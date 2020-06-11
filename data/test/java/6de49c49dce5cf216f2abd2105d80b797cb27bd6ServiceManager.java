package com.hisoft.util;

import com.hisoft.service.*;

public class ServiceManager {
	private UserService userService;

	private UserTypeService userTypeService;

	private UserResourceService userResourceService;

	private ProgramService programService;

	private TestAssetService testAssetService;

	private ActivityService activityService;

	private TargetMilestoneService targetMilestoneService;
	
	private TargetLaunchService targetLaunchService;
	
	private ResponsibleManagerService responsibleManagerService;
	
	private HPCostLocationService hpCostLocationService;
	
	private CountryLocaleService countryLocaleService;
	
	private VendorRateService vendorRateService;
	
	private RateMultService rateMultService;
	
	private BudgetTrackingService budgetTrackingService;
	
	private ChargeByProjectService chargeByProjectService;
	
	
	public ChargeByProjectService getChargeByProjectService() {
		return chargeByProjectService;
	}

	public void setChargeByProjectService(
			ChargeByProjectService chargeByProjectService) {
		this.chargeByProjectService = chargeByProjectService;
	}

	public BudgetTrackingService getBudgetTrackingService() {
		return budgetTrackingService;
	}

	public void setBudgetTrackingService(BudgetTrackingService budgetTrackingService) {
		this.budgetTrackingService = budgetTrackingService;
	}

	public RateMultService getRateMultService() {
		return rateMultService;
	}

	public void setRateMultService(RateMultService rateMultService) {
		this.rateMultService = rateMultService;
	}

	public VendorRateService getVendorRateService() {
		return vendorRateService;
	}

	public void setVendorRateService(VendorRateService vendorRateService) {
		this.vendorRateService = vendorRateService;
	}

	public CountryLocaleService getCountryLocaleService() {
		return countryLocaleService;
	}

	public void setCountryLocaleService(CountryLocaleService countryLocaleService) {
		this.countryLocaleService = countryLocaleService;
	}

	public HPCostLocationService getHpCostLocationService() {
		return hpCostLocationService;
	}

	public void setHpCostLocationService(HPCostLocationService hpCostLocationService) {
		this.hpCostLocationService = hpCostLocationService;
	}

	public ResponsibleManagerService getResponsibleManagerService() {
		return responsibleManagerService;
	}

	public void setResponsibleManagerService(
			ResponsibleManagerService responsibleManagerService) {
		this.responsibleManagerService = responsibleManagerService;
	}

	public TargetLaunchService getTargetLaunchService() {
		return targetLaunchService;
	}

	public void setTargetLaunchService(TargetLaunchService targetLaunchService) {
		this.targetLaunchService = targetLaunchService;
	}

	public TargetMilestoneService getTargetMilestoneService() {
		return targetMilestoneService;
	}

	public void setTargetMilestoneService(
			TargetMilestoneService targetMilestoneService) {
		this.targetMilestoneService = targetMilestoneService;
	}

	public ActivityService getActivityService() {
		return activityService;
	}

	public void setActivityService(ActivityService activityService) {
		this.activityService = activityService;
	}

	public TestAssetService getTestAssetService() {
		return testAssetService;
	}

	public void setTestAssetService(TestAssetService testAssetService) {
		this.testAssetService = testAssetService;
	}

	public ProgramService getProgramService() {
		return programService;
	}

	public void setProgramService(ProgramService programService) {
		this.programService = programService;
	}

	public UserResourceService getUserResourceService() {
		return userResourceService;
	}

	public void setUserResourceService(UserResourceService userResourceService) {
		this.userResourceService = userResourceService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public UserTypeService getUserTypeService() {
		return userTypeService;
	}

	public void setUserTypeService(UserTypeService userTypeService) {
		this.userTypeService = userTypeService;
	}

}
