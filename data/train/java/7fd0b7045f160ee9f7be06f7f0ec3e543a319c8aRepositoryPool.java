package com.eventpool.common.module;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.eventpool.common.repositories.CityRepository;
import com.eventpool.common.repositories.CountryRepository;
import com.eventpool.common.repositories.StateRepository;

@Component
public class RepositoryPool {

	@Resource
	private CityRepository cityRepository;
	
	@Resource
	private CountryRepository countryRepository;
	
	@Resource
	private StateRepository stateRepository;

	public CityRepository getCityRepository() {
		return cityRepository;
	}

	public void setCityRepository(CityRepository cityRepository) {
		this.cityRepository = cityRepository;
	}

	public CountryRepository getCountryRepository() {
		return countryRepository;
	}

	public void setCountryRepository(CountryRepository countryRepository) {
		this.countryRepository = countryRepository;
	}

	public StateRepository getStateRepository() {
		return stateRepository;
	}

	public void setStateRepository(StateRepository stateRepository) {
		this.stateRepository = stateRepository;
	}

}
