package points.web;

import org.apache.struts.action.Action;

import points.service.RegressionService;
import points.service.RegressionServiceAware;

/**
 * This class provides support for actions
 * that use the regression service.
 */
public abstract class 
RegressionServiceActionSupport
extends Action 
implements RegressionServiceAware {

	private RegressionService regressionService;

	public void setRegressionService(
	    RegressionService regressionService) {
		this.regressionService = 
			regressionService;
	}

	protected RegressionService 
	getRegressionService() {
		return regressionService;
	}
}