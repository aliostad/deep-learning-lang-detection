package credera.mvc.mongo.services;

import java.util.List;

import credera.mvc.mongo.model.City;
import credera.mvc.mongo.repository.CityRepository;

public class CityServiceImpl implements CityService {
	private CityRepository cityRepository;
	
	public void setCityRepository(CityRepository cityRepository) {
		this.cityRepository = cityRepository;
	}

	public City save(City city){
		return cityRepository.save(city);
	}

	public List<City> listCities(){
		return cityRepository.findAll();
	}
	public City findOne(String id){
		return cityRepository.findOne(id);
	}
}
