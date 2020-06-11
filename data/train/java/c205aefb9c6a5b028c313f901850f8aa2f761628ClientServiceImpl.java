package com.gsli.dr.domain.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.gsli.dr.domain.entity.Client;
import com.gsli.dr.domain.generic.GenericEntityServiceImpl;
import com.gsli.dr.domain.generic.GenericRepository;
import com.gsli.dr.domain.repository.ClientRepository;

public class ClientServiceImpl extends GenericEntityServiceImpl<Client, Long> implements ClientService{

	
	@Autowired
	private ClientRepository clientRepository;
	
	public ClientRepository getClientRepository() {
		return clientRepository;
	}

	public void setClientRepository(ClientRepository clientRepository) {
		this.clientRepository = clientRepository;
	}

	@Override
	public GenericRepository<Client, Long> getEntityRepository() {
		return getClientRepository();
	}

	@Override
	public boolean validateEntity(Client paramT) {
		return true;
	}

}
