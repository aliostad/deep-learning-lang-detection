package org.mattensoft.places.controller;

import javax.inject.Inject;
import javax.inject.Named;

import org.resthub.web.controller.RepositoryBasedRestController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.mattensoft.places.model.Place;
import org.mattensoft.places.repository.PlacesRepository;

@Controller
@RequestMapping(value = "/api/places")
public class PlaceController extends RepositoryBasedRestController<Place, String, PlacesRepository> {

    @Inject
    @Named("placesRepository")
    @Override
    public void setRepository(PlacesRepository repository) {
        this.repository = repository;
    }
}
