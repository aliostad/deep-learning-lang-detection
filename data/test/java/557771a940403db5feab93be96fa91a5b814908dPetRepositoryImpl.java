package org.springframework.roo.petclinic.repository;

import io.springlets.data.jpa.repository.support.QueryDslRepositorySupportExt;
import org.springframework.roo.addon.layers.repository.jpa.annotations.RooJpaRepositoryCustomImpl;
import org.springframework.roo.petclinic.domain.Pet;

/**
 * = PetRepositoryImpl
 *
 * TODO Auto-generated class documentation
 *
 */ 
@RooJpaRepositoryCustomImpl(repository = PetRepositoryCustom.class)
public class PetRepositoryImpl extends QueryDslRepositorySupportExt<Pet> {

    /**
     * TODO Auto-generated constructor documentation
     */
    PetRepositoryImpl() {
        super(Pet.class);
    }
}