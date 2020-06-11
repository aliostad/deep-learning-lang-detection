package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.AccTitleService;
import tw.com.skl.exp.kernel.model6.logic.DepartmentService;
import tw.com.skl.exp.kernel.model6.logic.SequenceService;

/**
 * 總帳日結單代傳票 Facade。
 * 
 * @author Sunkist Wang
 * @since 1.0, 2009/09/18
 */
public class SubpoenaDFacade {

    /**
     * 會計科目的 Service。
     */
    private AccTitleService accTitleService;
    
    /**
     * 組織單位的 Service。
     */
    private DepartmentService departmentService;

    /**
     * 序號表 Service
     */
    private SequenceService sequenceService;

    /**
     * 組織單位的 Service。
     * 
     * @return
     */
    public DepartmentService getDepartmentService() {
        return departmentService;
    }

    public void setDepartmentService(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    /**
     * 會計科目的 Service。
     * 
     * @return
     */
    public AccTitleService getAccTitleService() {
        return accTitleService;
    }

    public void setAccTitleService(AccTitleService accTitleService) {
        this.accTitleService = accTitleService;
    }

    public void setSequenceService(SequenceService sequenceService) {
        this.sequenceService = sequenceService;
    }

    public SequenceService getSequenceService() {
        return sequenceService;
    }

}
