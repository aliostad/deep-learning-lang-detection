/**
 * 
 */
package se.kth.mobdev.ruontime.service;

/**
 * @author Jasper
 *
 */
public class ServiceFactory {

	private static UserAuthenticationService userAuthService = new UserAuthenticationService();

	private static GroupService groupService = new GroupService();
	
	private static StatisticsService statisticsService = new StatisticsService();
	
	public static UserAuthenticationService getUserAuthService() {
		return userAuthService;
	}

	public static GroupService getGroupService() {
		return groupService;
	}

	public static StatisticsService getStatisticsService() {
		return statisticsService;
	}

}
