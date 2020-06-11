package org.sensor.logger.usecases;

import java.util.List;

import javax.inject.Inject;

import org.sensor.logger.contracts.SensorRepository;
import org.sensor.logger.model.Temperature;

public class ListTemperatures {

	  private SensorRepository sensorRepository;
	
	
	  public List<Temperature> listTemperatures() {
	        return sensorRepository.findTemperatures();
	  }



	@Inject
	public void setSensorRepository(SensorRepository sensorRepository) {
		this.sensorRepository = sensorRepository;
	}
	  
}
