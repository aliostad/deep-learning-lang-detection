/* **********************************************************************
 * Copyright 2013 VMware, Inc. All rights reserved. VMware Confidential
 * **********************************************************************
 */

package org.springframework.samples.petclinic.repository.vdo;

import org.springframework.samples.petclinic.model.Pet;
import org.springframework.samples.petclinic.repository.PetRepository;

import com.vmware.vdo.jpa.spring.repository.VirtualRepository;

/**
 * vDO specialization of the {@link PetRepository} interface
 * 
 * @author akanchev
 */
public interface VdoPetRepository extends PetRepository, VirtualRepository<Pet, Integer> {

}
