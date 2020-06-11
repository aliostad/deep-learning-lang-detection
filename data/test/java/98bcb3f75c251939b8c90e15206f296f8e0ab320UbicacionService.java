package com.journaldev.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.journaldev.spring.repository.UbicacionRepository;

@Component
public class UbicacionService {
	
	@Autowired
	private UbicacionRepository ubicacionRepository;

	public UbicacionRepository getUbicacionRepository() {
		return ubicacionRepository;
	}

	public void setUbicacionRepository(UbicacionRepository ubicacionRepository) {
		this.ubicacionRepository = ubicacionRepository;
	}

	
	
}
