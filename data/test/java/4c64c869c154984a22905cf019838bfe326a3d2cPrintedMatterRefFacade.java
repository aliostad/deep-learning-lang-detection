package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.ExpapplCDetailService;
import tw.com.skl.exp.kernel.model6.logic.UserService;

/**
 * 印刷品品名Facade
 * @author F224130414
 *
 */
public class PrintedMatterRefFacade {
	/**使用者的 Service */
    private UserService userService;
    
    /**費用明細 Service*/
    private ExpapplCDetailService expapplCDetailService;

	public ExpapplCDetailService getExpapplCDetailService() {
		return expapplCDetailService;
	}

	public void setExpapplCDetailService(ExpapplCDetailService expapplCDetailService) {
		this.expapplCDetailService = expapplCDetailService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
}
