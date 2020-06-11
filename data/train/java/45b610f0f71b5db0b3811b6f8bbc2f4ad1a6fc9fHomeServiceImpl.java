package org.tigersndragons.salonbooks.service.impl;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;
import org.tigersndragons.salonbooks.model.Appointment;
import org.tigersndragons.salonbooks.model.Employee;
import org.tigersndragons.salonbooks.service.AppointmentService;
import org.tigersndragons.salonbooks.service.HomeService;
import org.tigersndragons.salonbooks.service.OrderService;
import org.tigersndragons.salonbooks.service.PersonService;
import org.tigersndragons.salonbooks.service.ShippingMethodService;

public class HomeServiceImpl extends BaseServiceImpl  implements HomeService {


	private static final long serialVersionUID = 1L;

	private AppointmentService appointmentService;

	private PersonService personService;

	private OrderService orderService;

	private ShippingMethodService shipperService;

	public List<Appointment> findOpenAppointments(){	
		return appointmentService.getOpenAppointments();		
	}

	public List<Appointment> findOpenAppointmentsForEmployee(Employee emp) {
		return appointmentService.getOpenAppointmentsForEmployee(emp);
	}

	public AppointmentService getAppointmentService() {
		return appointmentService;
	}
	@Required
	public void setAppointmentService(AppointmentService appointmentService) {
		this.appointmentService = appointmentService;
	}

	public PersonService getPersonService() {
		return personService;
	}

	@Required
	public void setPersonService(PersonService personService) {
		this.personService = personService;
	}

	public OrderService getOrderService() {
		return orderService;
	}

	@Required
	public void setOrderService(OrderService orderService) {
		this.orderService = orderService;
	}

	public ShippingMethodService getShipperService() {
		return shipperService;
	}
	@Required
	public void setShipperService(ShippingMethodService shipperService) {
		this.shipperService = shipperService;
	}
	
}
