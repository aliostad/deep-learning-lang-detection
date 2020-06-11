package ua.rd.deliveryservice.service;

import ua.rd.deliveryservice.domain.Pizza;
import ua.rd.deliveryservice.repository.PizzaRepository;

/**
 *
 * @author andrii
 */
public class SimplePizzaService implements PizzaService{
    
    private PizzaRepository pizzaRepository;
    
    public SimplePizzaService(PizzaRepository pizzaRepository){
        this.pizzaRepository = pizzaRepository;
    }

    @Override
    public Pizza find(Integer id) {
        return pizzaRepository.find(id);
    } 
    
    public void init(){
    }
}
