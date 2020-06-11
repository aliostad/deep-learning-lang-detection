package net.svcret.admin.api;

public class AdminServiceProvider {

	private static AdminServiceProvider INSTANCE = new AdminServiceProvider();

	private IAdminServiceLocal myAdminService;
	private IChartingServiceBean myChartingService;

	public IAdminServiceLocal getAdminService() {
		return myAdminService;
	}

	public IChartingServiceBean getChartingService() {
		return myChartingService;
	}

	public void setAdminService(IAdminServiceLocal theAdminService) {
		myAdminService = theAdminService;
	}

	public void setChartingService(IChartingServiceBean theChartingService) {
		myChartingService = theChartingService;
	}

	public static AdminServiceProvider getInstance() {
		return INSTANCE;
	}

}
