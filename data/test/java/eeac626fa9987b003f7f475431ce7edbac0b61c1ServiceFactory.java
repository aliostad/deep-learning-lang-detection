package mindcape.service;

public class ServiceFactory {
	private static StoringService storingService=new StoringServiceImpl();
	private static ListingService listingService=new ListingServiceImpl();
	private static FilteringService filteringService=new FilteringServiceImpl();
	
	public static StoringService getStoringService() {
		return storingService;
	}
	
	public static ListingService getListingService() {
		return listingService;
	}
	
	public static FilteringService getFilteringService() {
		return filteringService;
	}
	
}
