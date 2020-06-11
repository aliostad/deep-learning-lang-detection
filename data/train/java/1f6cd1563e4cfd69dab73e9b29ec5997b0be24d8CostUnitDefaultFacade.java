/**
 * 
 */
package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.DepartmentService;
import tw.com.skl.exp.kernel.model6.logic.ExpItemService;
import tw.com.skl.exp.kernel.model6.logic.ExpTypeService;
import tw.com.skl.exp.kernel.model6.logic.ExpapplCService;
import tw.com.skl.exp.kernel.model6.logic.FunctionService;
import tw.com.skl.exp.kernel.model6.logic.MiddleTypeService;

/**
 * @author timchiang
 *
 */
public class CostUnitDefaultFacade {

    /**組織單位的 Service*/
    private DepartmentService departmentService;
    /**行政費用申請單 Service*/
    private ExpapplCService expapplCService;
    /**費用項目 Service*/
    private ExpItemService expItemService;
    /**功能的 Service*/
    private FunctionService functionService;
    /**費用性質 Service*/
    private ExpTypeService expTypeService;
    /**費用中分類 Service*/
    private MiddleTypeService middleTypeService;

    /**
     * @param 費用項目 Service
     */
    public void setExpItemService(ExpItemService expItemService) {
        this.expItemService = expItemService;
    }

    /**
     * @return 費用項目 Service
     */
    public ExpItemService getExpItemService() {
        return expItemService;
    }

    /**
     * @param 功能的 Service
     */
    public void setFunctionService(FunctionService functionService) {
        this.functionService = functionService;
    }

    /**
     * @return 功能的 Service
     */
    public FunctionService getFunctionService() {
        return functionService;
    }

    /**
     * @param 組織單位的 Service
     */
    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    /**
     * @return 組織單位的 Service
     */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    /**
     * @param 行政費用申請單 Service
     */
    public void setExpapplCService(ExpapplCService expapplCService) {
        this.expapplCService = expapplCService;
    }

    /**
     * @return 行政費用申請單 Service
     */
    public ExpapplCService getExpapplCService() {
        return expapplCService;
    }

    /**
     * @param 費用性質 Service
     */
    public void setExpTypeService(ExpTypeService expTypeService) {
        this.expTypeService = expTypeService;
    }

    /**
     * @return 費用性質 Service
     */
    public ExpTypeService getExpTypeService() {
        return expTypeService;
    }

    /**
     * @param 費用中分類 Service
     */
    public void setMiddleTypeService(MiddleTypeService middleTypeService) {
        this.middleTypeService = middleTypeService;
    }

    /**
     * @return 費用中分類 Service
     */
    public MiddleTypeService getMiddleTypeService() {
        return middleTypeService;
    }

}
