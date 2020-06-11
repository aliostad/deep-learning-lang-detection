package foodselector.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import foodselector.domain.Vegetables;
import foodselector.repository.VegetablesRepository;

@Service
public class VegetablesService extends AbstractService<Vegetables, Long> implements
		IVegetablesService {

	private VegetablesRepository vegetablesRepository;

	@Autowired
	public void setVegetablesRepository(VegetablesRepository vegetablesRepository) {
		this.vegetablesRepository = vegetablesRepository;
		super.setRepository(vegetablesRepository);
	}

	@Override
	public Vegetables findByName(String name) {
		return vegetablesRepository.findByName(name);		
	}
	

}
