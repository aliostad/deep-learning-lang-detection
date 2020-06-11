package foodselector.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import foodselector.domain.Dish;
import foodselector.repository.DishRepository;

@Service
public class DishService extends AbstractService<Dish, Long> implements
		IDishService {
	
	private DishRepository dishRepository;

	@Autowired
	public void setDishRepository(DishRepository dishRepository) {
		this.dishRepository = dishRepository;
		super.setRepository(dishRepository);
	}
	
	

}
