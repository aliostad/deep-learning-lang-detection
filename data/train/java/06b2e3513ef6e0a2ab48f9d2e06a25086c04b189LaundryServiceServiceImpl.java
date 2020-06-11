package elaundry.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import elaundry.domain.LaundryService;
import elaundry.repository.LaundryServiceRepository;
import elaundry.service.LaundryServiceService;

@Service
@Transactional
public class LaundryServiceServiceImpl implements LaundryServiceService {
	
	@Autowired
	private LaundryServiceRepository laundryServiceRepository;
	
	public void addLaundryService(LaundryService service) {
		laundryServiceRepository.save(service);
	}
	
	public LaundryService getLaundryServiceById(int id) {
		return laundryServiceRepository.findOne(id);
	}
	
	public List<LaundryService> getLaundryServcies() {
		return (List<LaundryService>)laundryServiceRepository.findAll();
	}
}
