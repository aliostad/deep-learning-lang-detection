package com.taxi.config;

import com.taxi.service.TaxiCarService;
import com.taxi.service.TaxiDriverService;
import com.taxi.service.TaxiParkService;

public class ApplicationConfiguration implements Configuration {

	private final TaxiParkService parkService;
	private final TaxiCarService carService;
	private final TaxiDriverService driverService;

	public ApplicationConfiguration(TaxiParkService parkService,
			TaxiCarService carService, TaxiDriverService driverService) {
		this.parkService = parkService;
		this.carService = carService;
		this.driverService = driverService;
	}

	@Override
	public TaxiParkService getParkService() {
		return parkService;
	}

	@Override
	public TaxiCarService getCarService() {
		return carService;
	}

	@Override
	public TaxiDriverService getDriverService() {
		return driverService;
	}
}
