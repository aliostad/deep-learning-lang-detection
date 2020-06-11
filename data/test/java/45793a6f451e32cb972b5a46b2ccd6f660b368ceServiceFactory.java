package elacier.service;

public class ServiceFactory {
	
	private static OrderService orderService;
	
	private static IRestaurantService restaurantService;
	
	private static IRestaurantService proxyRestaurantService;
	
	
	public static OrderService getOrderService() {
		if (orderService == null) {
			orderService = new OrderService();
		}
		return orderService;
	}

	
	
	public static IRestaurantService getRestaurantService() {
		if (proxyRestaurantService == null) {
			restaurantService = new RestaurantServiceDBImpl();
			proxyRestaurantService  = new RestaurantServiceProxy((RestaurantServiceDBImpl)restaurantService);
		}
		return proxyRestaurantService;
	}
}
