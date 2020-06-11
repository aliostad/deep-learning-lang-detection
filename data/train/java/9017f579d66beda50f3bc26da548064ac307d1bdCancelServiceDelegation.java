/**
 * 
 */
package com.virtusa.lp28.obr.delegation;

import com.virtusa.lp28.obr.form.CancelServiceForm;
import com.virtusa.lp28.obr.interfaces.CancelServiceI;
import com.virtusa.lp28.obr.service.ServiceLocator;

/**
 * @author adarshb
 *
 */
public class CancelServiceDelegation implements CancelServiceI {

	@Override
	public boolean cancelService(CancelServiceForm cancelServiceForm) {
	  CancelServiceI cancelService= (CancelServiceI)ServiceLocator.getService(CancelServiceI.class.getName());
	 return cancelService.cancelService(cancelServiceForm);
		
	}

}
