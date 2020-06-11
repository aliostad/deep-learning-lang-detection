package com.xenogears.cotizacion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.xenogears.cotizacion.repository.CotizacionRepository;

@Component
public class CotizacionService {
	
	@Autowired
	CotizacionRepository cotizacionRepository;

	public CotizacionRepository getCotizacionRepository() {
		return cotizacionRepository;
	}

	public void setCotizacionRepository(CotizacionRepository cotizacionRepository) {
		this.cotizacionRepository = cotizacionRepository;
	}
	
	
}
