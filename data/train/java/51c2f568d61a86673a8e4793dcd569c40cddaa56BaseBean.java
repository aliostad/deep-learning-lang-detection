package ar.edu.unju.fi.bean;

import ar.edu.unju.fi.services.ServiceFacade;
import ar.edu.unju.fi.services.SpringUtil;

/**
 * Superclase de todos los beans
 *
 */
public class BaseBean {
	ServiceFacade service;

	/**
	 * Constructor del bean
	 */
	public BaseBean() {
		service = (ServiceFacade) SpringUtil.getBean("serviceFacade");
	}

	
	//Getter y Setter del atributo service
	
	public ServiceFacade getService() {
		if (service == null)
			service = (ServiceFacade) SpringUtil.getBean("serviceFacade");
		return service;
	}

	public void setService(ServiceFacade service) {
		this.service = service;
	}

}
