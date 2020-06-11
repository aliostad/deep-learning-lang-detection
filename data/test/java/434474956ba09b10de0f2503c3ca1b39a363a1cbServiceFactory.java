package in.darkstars.service;

import in.darkstars.helper.Constant;

/**
 * @author dis-card
 *
 */
public class ServiceFactory {
	
	private static UserService userService = null;
	
	public static Service getService(String serviceType)
	{
		Service service = null;
		if ( serviceType.equals(Constant.USER))
		{
			if (userService == null )
			{
				synchronized(UserService.class)
				{
					if (userService == null)
						userService = new UserService();
				}
			}
			service = userService;
			
		}
		
		
		
		
		
		
		return service;
	}

}
