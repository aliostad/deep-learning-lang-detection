package com.spean90.schema.chainofrespinsibility.handler;

public class HandlerFactory {

	public static RequestHandler createHandler() {
		RequestHandler sale = new Sales();
		RequestHandler manager = new Manager();
		RequestHandler director = new Director();
		RequestHandler vicePresident = new VicePresident();
		RequestHandler ceo = new CEO();
		sale.setNextHandler(manager);
		manager.setNextHandler(director);
		director.setNextHandler(vicePresident);
		vicePresident.setNextHandler(ceo);
		return sale;
	}
}
