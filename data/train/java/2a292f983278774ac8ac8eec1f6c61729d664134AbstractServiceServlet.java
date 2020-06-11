package com.noelmace.gestionclient.spring.web.servlets;

import org.springframework.web.HttpRequestHandler;

import com.noelmace.gestionclient.spring.business.services.ClientService;
import com.noelmace.gestionclient.spring.business.services.OrderingService;


public abstract class AbstractServiceServlet implements HttpRequestHandler {
		
	protected ClientService clientService;
	protected OrderingService orderingService;

	public void setClientService(ClientService clientService) {
		this.clientService = clientService;
	}

	public void setOrderingService(OrderingService orderingService) {
		this.orderingService = orderingService;
	}
}
