package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.AccTitleService;
import tw.com.skl.exp.kernel.model6.logic.ApplInfoService;
import tw.com.skl.exp.kernel.model6.logic.BizMatterService;
import tw.com.skl.exp.kernel.model6.logic.CostUnitDefaultService;
import tw.com.skl.exp.kernel.model6.logic.DepartmentService;
import tw.com.skl.exp.kernel.model6.logic.DrawAccountTypeService;
import tw.com.skl.exp.kernel.model6.logic.EntryGroupService;
import tw.com.skl.exp.kernel.model6.logic.EntryService;
import tw.com.skl.exp.kernel.model6.logic.EntryTypeService;
import tw.com.skl.exp.kernel.model6.logic.ExpYearsService;
import tw.com.skl.exp.kernel.model6.logic.ExpapplCService;
import tw.com.skl.exp.kernel.model6.logic.FlowCheckstatusService;
import tw.com.skl.exp.kernel.model6.logic.IncomeIdTypeService;
import tw.com.skl.exp.kernel.model6.logic.IncomeUserService;
import tw.com.skl.exp.kernel.model6.logic.OvsaExpDrawInfoService;
import tw.com.skl.exp.kernel.model6.logic.OvsaTrvlLrnExpItemService;
import tw.com.skl.exp.kernel.model6.logic.StationExpDetailService;
import tw.com.skl.exp.kernel.model6.logic.StationService;
import tw.com.skl.exp.kernel.model6.logic.TransitPaymentDetailService;
import tw.com.skl.exp.kernel.model6.logic.UserService;
import tw.com.skl.exp.kernel.model6.logic.ZoneTypeService;


/**
 * 國外研修差旅費用Facade
 * @author Eustace
 */
public class OvsaTrvlLrnExpFacade {
    
    /**使用者的 Service */
    private UserService userService;
    
    /**申請人資訊 Service */
    private ApplInfoService applInfoService;
    
    /**組織單位的 Service */
    private DepartmentService departmentService;
    
    /**行政費用申請單 Service */
    private ExpapplCService expapplCService;
    
    /**過渡付款明細 Service */
    private TransitPaymentDetailService transitPaymentDetailService;

    /**流程簽核歷程 Service */
    private FlowCheckstatusService flowCheckstatusService;
    
    /**國外研修差旅費用領款資料 Service */
    private OvsaExpDrawInfoService ovsaExpDrawInfoService;
    
    /**領款帳號類 Service */
    private DrawAccountTypeService drawAccountTypeService;
    
    /**地域別 Service */
    private ZoneTypeService zoneTypeService;
    
    /**駐在地點 Service */
    private StationService stationService;
    
    /**駐在地點之費用明細 Service */
    private StationExpDetailService stationExpDetailService;
    
    /**國外差旅費用項目 Service */
    private OvsaTrvlLrnExpItemService ovsaTrvlLrnExpItemService;
    
    /**會計科目的 Service */
    private AccTitleService accTitleService;
    
    /**出差事由 Service */
    private BizMatterService bizMatterService;
    
    /**分錄群組 Service*/
    private EntryGroupService entryGroupService;
    
    /**分錄 Service */
    private EntryService entryService;
    
    /**分錄借貸別 Service*/
    private EntryTypeService entryTypeService;
    
    /**成本單位預設對照表 Service*/
    private CostUnitDefaultService costUnitDefaultService;
    
    /**所得人證號類別 Service */
    private IncomeIdTypeService incomeIdTypeService;
    
    /**所得人資料 Service */
    private IncomeUserService incomeUserService;

    //PeterYu 20120801 RE201200382 Add start 
    /** 費用年月 Service */
    private ExpYearsService expYearsService;
  //PeterYu 20120801 RE201200382 Add end 
    
    /**所得人資料 Service */
    public IncomeUserService getIncomeUserService() {
		return incomeUserService;
	}

    /**所得人資料 Service */
	public void setIncomeUserService(IncomeUserService incomeUserService) {
		this.incomeUserService = incomeUserService;
	}

	/**使用者的 Service */
    public UserService getUserService() {
        return userService;
    }

    /**使用者的 Service */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    /**申請人資訊 Service */
    public ApplInfoService getApplInfoService() {
        return applInfoService;
    }

    /**申請人資訊 Service */
    public void setApplInfoService(ApplInfoService applInfoService) {
        this.applInfoService = applInfoService;
    }

    /**組織單位的 Service */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    /**組織單位的 Service */
    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    /**行政費用申請單 Service */
    public ExpapplCService getExpapplCService() {
        return expapplCService;
    }

    /**行政費用申請單 Service */
    public void setExpapplCService(ExpapplCService expapplCService) {
        this.expapplCService = expapplCService;
    }

    /**過渡付款明細 Service */
    public TransitPaymentDetailService getTransitPaymentDetailService() {
        return transitPaymentDetailService;
    }

    /**過渡付款明細 Service */
    public void setTransitPaymentDetailService(TransitPaymentDetailService transitPaymentDetailService) {
        this.transitPaymentDetailService = transitPaymentDetailService;
    }

    /**流程簽核歷程 Service */
    public FlowCheckstatusService getFlowCheckstatusService() {
        return flowCheckstatusService;
    }

    /**流程簽核歷程 Service */
    public void setFlowCheckstatusService(FlowCheckstatusService flowCheckstatusService) {
        this.flowCheckstatusService = flowCheckstatusService;
    }

    /**國外研修差旅費用領款資料 Service */
    public OvsaExpDrawInfoService getOvsaExpDrawInfoService() {
        return ovsaExpDrawInfoService;
    }

    /**國外研修差旅費用領款資料 Service */
    public void setOvsaExpDrawInfoService(OvsaExpDrawInfoService ovsaExpDrawInfoService) {
        this.ovsaExpDrawInfoService = ovsaExpDrawInfoService;
    }

    /**領款帳號類 Service */
    public DrawAccountTypeService getDrawAccountTypeService() {
        return drawAccountTypeService;
    }

    /**領款帳號類 Service */
    public void setDrawAccountTypeService(DrawAccountTypeService drawAccountTypeService) {
        this.drawAccountTypeService = drawAccountTypeService;
    }

    /**地域別 Service */
    public ZoneTypeService getZoneTypeService() {
        return zoneTypeService;
    }

    /**地域別 Service */
    public void setZoneTypeService(ZoneTypeService zoneTypeService) {
        this.zoneTypeService = zoneTypeService;
    }

    /**駐在地點 Service */
    public StationService getStationService() {
        return stationService;
    }

    /**駐在地點 Service */
    public void setStationService(StationService stationService) {
        this.stationService = stationService;
    }

    /**駐在地點之費用明細 Service */
    public StationExpDetailService getStationExpDetailService() {
        return stationExpDetailService;
    }

    /**駐在地點之費用明細 Service */
    public void setStationExpDetailService(StationExpDetailService stationExpDetailService) {
        this.stationExpDetailService = stationExpDetailService;
    }

    /**國外差旅費用項目 Service */
    public OvsaTrvlLrnExpItemService getOvsaTrvlLrnExpItemService() {
        return ovsaTrvlLrnExpItemService;
    }

    /**國外差旅費用項目 Service */
    public void setOvsaTrvlLrnExpItemService(OvsaTrvlLrnExpItemService ovsaTrvlLrnExpItemService) {
        this.ovsaTrvlLrnExpItemService = ovsaTrvlLrnExpItemService;
    }

    /**會計科目的 Service */
    public AccTitleService getAccTitleService() {
        return accTitleService;
    }

    /**會計科目的 Service */
    public void setAccTitleService(AccTitleService accTitleService) {
        this.accTitleService = accTitleService;
    }

    /**出差事由 Service */
    public BizMatterService getBizMatterService() {
        return bizMatterService;
    }

    /**出差事由 Service */
    public void setBizMatterService(BizMatterService bizMatterService) {
        this.bizMatterService = bizMatterService;
    }

    /**分錄群組 Service*/
    public EntryGroupService getEntryGroupService() {
        return entryGroupService;
    }

    /**分錄群組 Service*/
    public void setEntryGroupService(EntryGroupService entryGroupService) {
        this.entryGroupService = entryGroupService;
    }

    /**分錄 Service */
    public EntryService getEntryService() {
        return entryService;
    }

    /**分錄 Service */
    public void setEntryService(EntryService entryService) {
        this.entryService = entryService;
    }

    /**分錄借貸別 Service*/
    public EntryTypeService getEntryTypeService() {
        return entryTypeService;
    }

    /**分錄借貸別 Service*/
    public void setEntryTypeService(EntryTypeService entryTypeService) {
        this.entryTypeService = entryTypeService;
    }

    /**成本單位預設對照表 Service*/
    public CostUnitDefaultService getCostUnitDefaultService() {
        return costUnitDefaultService;
    }

    /**成本單位預設對照表 Service*/
    public void setCostUnitDefaultService(CostUnitDefaultService costUnitDefaultService) {
        this.costUnitDefaultService = costUnitDefaultService;
    }

    /**所得人證號類別 Service */
    public IncomeIdTypeService getIncomeIdTypeService() {
        return incomeIdTypeService;
    }
    /**所得人證號類別 Service */
    public void setIncomeIdTypeService(IncomeIdTypeService incomeIdTypeService) {
        this.incomeIdTypeService = incomeIdTypeService;
    }
    
    //PeterYu 20120801 RE201200382 Add start 
	public ExpYearsService getExpYearsService() {
		return expYearsService;
	}

	public void setExpYearsService(ExpYearsService expYearsService) {
		this.expYearsService = expYearsService;
	}
    //PeterYu 20120801 RE201200382 Add end
}
