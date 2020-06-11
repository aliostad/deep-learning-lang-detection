/**

	@Author sardarwaqasahmed
	@date   Dec 9, 2013
	 1.0
**/

package com.ihm.customer.service;

import java.io.Serializable;

import com.ihm.customer.dao.impl.ProductDAOImpl;
import com.ihm.customer.faces.bean.SessionBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

@Service
public class ManagerService implements Serializable {


	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8959403423498238016L;
	
	@Autowired
	private SearchService searchService;

	@Autowired
	private AmenitiesService amenitiesService;
	
	@Autowired
	private CalendarService calendarService;
	
	@Autowired
	private CustomerAppointmentService customerAppointmentService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private SMSService smsService;

    @Autowired
    private ProductService productService;


	public SMSService getSmsService() {
		return smsService;
	}

	public void setSmsService(SMSService smsService) {
		this.smsService = smsService;
	}
	public SearchService getSearchService() {
		return searchService;
	}

	public void setSearchService(SearchService searchService) {
		this.searchService = searchService;
	}

	public AmenitiesService getAmenitiesService() {
		return amenitiesService;
	}

	public void setAmenitiesService(AmenitiesService amenitiesService) {
		this.amenitiesService = amenitiesService;
	}

	public CalendarService getCalendarService() {
		return calendarService;
	}

	public void setCalendarService(CalendarService calendarService) {
		this.calendarService = calendarService;
	}

	public CustomerAppointmentService getCustomerAppointmentService() {
		return customerAppointmentService;
	}

	public void setCustomerAppointmentService(
			CustomerAppointmentService customerAppointmentService) {
		this.customerAppointmentService = customerAppointmentService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

    public ProductService getProductService() {
        return productService;
    }

    public void setProductService(ProductService productService) {
        this.productService = productService;
    }
}
