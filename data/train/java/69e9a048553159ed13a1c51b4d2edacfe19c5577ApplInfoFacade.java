package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.DepartmentService;
import tw.com.skl.exp.kernel.model6.logic.UserService;


/**
 * 申請人資訊 Facade 。
 * 
 * @author Eustace
 * @version 1.0, 2009/8/4
 */
public class ApplInfoFacade {
    
    /**組織單位的 Service */
    private DepartmentService departmentService;
    
    /**使用者的 Service */
    private UserService userService;

    /**
     * 組織單位的 Service 
     */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    /**
     * 組織單位的 Service 
     */
    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    /**使用者的 Service */
    public UserService getUserService() {
        return userService;
    }

    /**使用者的 Service */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
}
