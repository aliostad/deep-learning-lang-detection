package com.monolitospizza.services;

import com.monolitospizza.model.*;
import com.monolitospizza.repositories.CrustRepository;
import com.monolitospizza.repositories.SauceRepository;
import com.monolitospizza.repositories.SizeRepository;
import com.monolitospizza.repositories.ToppingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author Matt Stine
 */
@Service
public class MenuService {
    private final SizeRepository sizeRepository;
    private final CrustRepository crustRepository;
    private final SauceRepository sauceRepository;
    private final ToppingRepository toppingRepository;

    @Autowired
    public MenuService(SizeRepository sizeRepository, CrustRepository crustRepository, SauceRepository sauceRepository, ToppingRepository toppingRepository) {
        this.sizeRepository = sizeRepository;
        this.crustRepository = crustRepository;
        this.sauceRepository = sauceRepository;
        this.toppingRepository = toppingRepository;
    }

    public BasePizzaMenuOptions loadBasePizzaMenuOptions() {
        Iterable<Size> sizes = sizeRepository.findAll();
        Iterable<Crust> crusts = crustRepository.findAll();
        Iterable<Sauce> sauces = sauceRepository.findAll();

        return new BasePizzaMenuOptions(sizes, crusts, sauces);
    }

    public Pizza loadDefaultPizzaConfiguration() {
        return new Pizza(sizeRepository.findOneByName("Large"),
                crustRepository.findOneByName("Thin"),
                sauceRepository.findOneByName("Normal"));
    }

    public Iterable<Topping> loadToppingOptions() {
        return toppingRepository.findAll();
    }

    public Topping loadTopping(long id) {
        return toppingRepository.findOne(id);
    }
}
