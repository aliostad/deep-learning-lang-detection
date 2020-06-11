package com.xenogears.cotizacion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xenogears.cotizacion.repository.VendedorRepository;

@Component
public class VendedorService {
	
	@Autowired
	private VendedorRepository vendedorRepository;


	public VendedorRepository getVendedorRepository() {
		return vendedorRepository;
	}

	public void setVendedorRepository(VendedorRepository vendedorRepository) {
		this.vendedorRepository = vendedorRepository;
	}
	
}
