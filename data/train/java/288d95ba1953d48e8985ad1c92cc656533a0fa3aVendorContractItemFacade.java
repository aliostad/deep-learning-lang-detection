package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.DepartmentService;

public class VendorContractItemFacade {

    /**組織單位的 Service */
    private DepartmentService departmentService;

    /**組織單位的 Service */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    /**組織單位的 Service */
    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }
    
    

}
