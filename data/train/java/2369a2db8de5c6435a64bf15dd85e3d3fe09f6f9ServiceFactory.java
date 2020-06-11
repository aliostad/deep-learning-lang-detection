/**
 * 
 */
package org.anaolabs.spring.orange.factories;

import org.anaolabs.spring.orange.service.ContractService;
import org.anaolabs.spring.orange.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;


/**
 * @author SDSB3717
 *
 */
//@Component
@Service
public class ServiceFactory {

	@Autowired
	private UserService userService;
	
	@Autowired
	private ContractService contractService;
	
	public UserService getUserService() {
		return userService;
	}
	
	public ContractService getContractService() {
		return contractService;
	}
	
}
