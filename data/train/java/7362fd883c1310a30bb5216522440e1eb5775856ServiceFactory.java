package com.jfetek.demo.weather.api;

import com.jfetek.demo.weather.api.impl.*;

public final class ServiceFactory {
	
	private static ServiceFactory instance = new ServiceFactory();
	
	public static ServiceFactory getInstance() {
		return instance;
	}

	private StationService stationService = new StationServiceImpl();
	
	private WeatherService weatherService = new WeatherServiceImpl();
	
	public StationService stationService() {
		return stationService;
	}
	
	public void setStationService(StationService stationService) {
		this.stationService = stationService;
	}

	public WeatherService weatherService() {
		return weatherService;
	}

	public void setWeatherService(WeatherService weatherService) {
		this.weatherService = weatherService;
	}
}
