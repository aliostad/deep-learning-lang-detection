package domain.service;

public class GarageServiceProvider {
	private static BillService billService = new BillService();
	private static CustomerService custService = new CustomerService();
	private static AppointmentService appService = new AppointmentService();
	private static EmployeeService empService = new EmployeeService();
	private static LetterService letService = new LetterService();
	private static ParkingBookingService parkService = new ParkingBookingService();
	private static CarService carService = new CarService();
	private static OrderService ordService = new OrderService();
	private static ArticleService artService = new ArticleService();
	private static FuelService fuelService = new FuelService();
	
	public static BillService getBillService() {
		return billService;
	}

	public static CustomerService getCustService() {
		return custService;
	}

	public static AppointmentService getAppService() {
		return appService;
	}

	public static EmployeeService getEmpService() {
		return empService;
	}

	public static LetterService getLetService() {
		return letService;
	}

	public static ParkingBookingService getParkService() {
		return parkService;
	}

	public static CarService getCarService() {
		return carService;
	}

	public static OrderService getOrdService() {
		return ordService;
	}

	public static ArticleService getArtService() {
		return artService;
	}

	public static FuelService getFuelService() {
		return fuelService;
	}

	public static BillService getUserService() {
		return billService;
	}
}
