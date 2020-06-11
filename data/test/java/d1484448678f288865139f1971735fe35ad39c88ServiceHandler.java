package service.impl;

import service.IAppointmentService;
import service.IBookingService;
import service.IHorseService;

/**
 * Singleton that works just like DAOHandler and gets the Singleton instances of
 * all of the various Service interfaces.
 * 
 * @author David Wietstruk 0706376
 *
 */
public class ServiceHandler {

	private static ServiceHandler serviceHandler = null;
	private IBookingService bService = null;
	private IHorseService hService = null;
	private IAppointmentService aService = null;

	private ServiceHandler() {

	}

	public static synchronized ServiceHandler getInstance() {
		if (serviceHandler == null)
			serviceHandler = new ServiceHandler();

		return serviceHandler;
	}

	public IBookingService getBookingService() {
		if (bService == null) {
			bService = new BookingService();
			return bService;
		} else
			return bService;
	}

	public IHorseService getHorseService() {

		if (hService == null) {
			hService = new HorseService();
			return hService;
		} else
			return hService;
	}

	public IAppointmentService getAppointmentService() {
		if (aService == null) {
			aService = new AppointmentService();
			return aService;
		} else
			return aService;
	}

}
