package org.springframework.roo.petclinic.repository;

import io.springlets.data.jpa.repository.support.QueryDslRepositorySupportExt;
import org.springframework.roo.addon.layers.repository.jpa.annotations.RooJpaRepositoryCustomImpl;
import org.springframework.roo.petclinic.domain.Owner;

/**
 * = OwnerRepositoryImpl
 *
 * TODO Auto-generated class documentation
 *
 */ 
@RooJpaRepositoryCustomImpl(repository = OwnerRepositoryCustom.class)
public class OwnerRepositoryImpl extends QueryDslRepositorySupportExt<Owner> {

    /**
     * TODO Auto-generated constructor documentation
     */
    OwnerRepositoryImpl() {
        super(Owner.class);
    }
}