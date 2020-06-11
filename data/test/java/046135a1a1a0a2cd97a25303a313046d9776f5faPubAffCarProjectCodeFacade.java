/**
 * 
 */
package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.UserService;



/**
 * 公務車專案代號檔 Facade
 */
public class PubAffCarProjectCodeFacade {

    /**使用者的 Service */
    private UserService userService;

    /**使用者的 Service */
    public UserService getUserService() {
        return userService;
    }

    /**使用者的 Service */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
}
