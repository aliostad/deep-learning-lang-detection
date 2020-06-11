package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.AccTitleService;
import tw.com.skl.exp.kernel.model6.logic.BigTypeService;
import tw.com.skl.exp.kernel.model6.logic.CurrencyService;
import tw.com.skl.exp.kernel.model6.logic.DepartmentService;
import tw.com.skl.exp.kernel.model6.logic.EntryService;
import tw.com.skl.exp.kernel.model6.logic.MiddleTypeService;
import tw.com.skl.exp.kernel.model6.logic.UserService;

/**
 * 過渡付款明細 Facade
 * 
 * @author Eustace
 */
public class TransitPaymentDetailFacade {

    /** 大分類 Service */
    private BigTypeService bigTypeService;

    /** 組織單位 Service */
    private DepartmentService departmentService;

    /** 分錄 Service */
    private EntryService entryService;

    /** 幣別 Service */
    private CurrencyService currencyService;

    /** 使用者的 Service */
    private UserService userService;

    /** 會計科目的 Service */
    private AccTitleService accTitleService;
    
    /**費用中分類 Service*/
    private MiddleTypeService middleTypeService;

    /**
     * 組織單位 Service
     */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    /**
     * 組織單位 Service
     */
    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    /**
     * 幣別 Service
     */
    public CurrencyService getCurrencyService() {
        return currencyService;
    }

    /**
     * 幣別 Service
     */
    public void setCurrencyService(CurrencyService currencyService) {
        this.currencyService = currencyService;
    }

    /** 使用者的 Service */
    public UserService getUserService() {
        return userService;
    }

    /** 使用者的 Service */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setEntryService(EntryService entryService) {
        this.entryService = entryService;
    }

    public EntryService getEntryService() {
        return entryService;
    }

    /** 會計科目的 Service */
    public AccTitleService getAccTitleService() {
        return accTitleService;
    }

    /** 會計科目的 Service */
    public void setAccTitleService(AccTitleService accTitleService) {
        this.accTitleService = accTitleService;
    }

    public void setBigTypeService(BigTypeService bigTypeService) {
        this.bigTypeService = bigTypeService;
    }

    /** 大分類 Service */
    public BigTypeService getBigTypeService() {
        return bigTypeService;
    }

    /** 費用中分類 Service */
    public MiddleTypeService getMiddleTypeService() {
        return middleTypeService;
    }

    /** 費用中分類 Service */
    public void setMiddleTypeService(MiddleTypeService middleTypeService) {
        this.middleTypeService = middleTypeService;
    }
}
