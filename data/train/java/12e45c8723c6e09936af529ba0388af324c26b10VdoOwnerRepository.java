/* **********************************************************************
 * Copyright 2013 VMware, Inc. All rights reserved. VMware Confidential
 * **********************************************************************
 */

package org.springframework.samples.petclinic.repository.vdo;


import org.springframework.samples.petclinic.model.Owner;
import org.springframework.samples.petclinic.repository.OwnerRepository;

import com.vmware.vdo.jpa.spring.repository.VirtualRepository;

/**
 * vDO specialization of the {@link OwnerRepository} interface
 * 
 * @author akanchev
 */
public interface VdoOwnerRepository extends OwnerRepository, VirtualRepository<Owner, Integer> {

}
