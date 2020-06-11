/*******************************************************************************************
 * Copyright (c) Igor R. Dejanović <igor DOT dejanovic AT gmail DOT com>
 * See LICENSE file which accompanies this distribution.
 *******************************************************************************************/
package net.sleworks.morp.repository.impl;

import net.sleworks.morp.repository.IBackendObject;
import net.sleworks.morp.repository.IRepository;
import net.sleworks.morp.repository.IRepositoryObject;
import net.sleworks.morp.repository.RepositoryObjectType;


public class RepositoryObject extends RepositoryElement implements IRepositoryObject {
	
	public RepositoryObject(IRepository repository, IBackendObject backendObject) {
		super(repository, backendObject);
	}

	@Override
	public RepositoryObjectType getRepositoryObjectType() {
		return RepositoryObjectType.valueOf((String)getRepository().getProperty(this, REPOSITORY_ELEMENT_PROPERTY_TYPE_NAME));
	}


}
