/**
 * 
 */
package tw.com.skl.exp.kernel.model6.facade;

import tw.com.skl.exp.kernel.model6.logic.ApplStateService;
import tw.com.skl.exp.kernel.model6.logic.BigTypeService;
import tw.com.skl.exp.kernel.model6.logic.DailyStatementService;
import tw.com.skl.exp.kernel.model6.logic.EntryService;
import tw.com.skl.exp.kernel.model6.logic.ExpapplCService;
import tw.com.skl.exp.kernel.model6.logic.FlowCheckstatusService;
import tw.com.skl.exp.kernel.model6.logic.PaymentBatchService;
import tw.com.skl.exp.kernel.model6.logic.SequenceService;
import tw.com.skl.exp.kernel.model6.logic.SubpoenaService;
import tw.com.skl.exp.kernel.model6.logic.SysTypeService;
import tw.com.skl.exp.kernel.model6.logic.TransitPaymentDetailService;
import tw.com.skl.exp.kernel.model6.logic.UserService;

/**
 * @author timchiang
 * 
 */
public class PaymentDetailFacade {

    /** 申請單狀態 Service */
    private ApplStateService applStateService;
    /** 分錄 Service */
    private EntryService entryService;
    /** 行政費用申請單 Service */
    private ExpapplCService expapplCService;
    /** 流程簽核歷程 Service */
    private FlowCheckstatusService flowCheckstatusService;
    /** 送匯批次記錄Service */
    private PaymentBatchService paymentBatchService;
    /** 序號表 Service */
    private SequenceService sequenceService;
    /** 日結單代傳票 Service */
    private SubpoenaService subpoenaService;
    /** 子系統別 Service */
    private SysTypeService sysTypeService;
    /** 過渡付款明細 Service */
    private TransitPaymentDetailService transitPaymentDetailService;
    /** 使用者的 Service */
    private UserService userService;
    /** 大分類 Service */
    private BigTypeService bigTypeService;
    /**日計表 Service*/
    private DailyStatementService dailyStatementService;

    /**
     * @param 申請單狀態
     *            Service
     */
    public void setApplStateService(ApplStateService applStateService) {
        this.applStateService = applStateService;
    }

    /**
     * @return 申請單狀態 Service
     */
    public ApplStateService getApplStateService() {
        return applStateService;
    }

    /**
     * @param 行政費用申請單
     *            Service
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
     * @param 日結單代傳票
     *            Service
     */
    public void setSubpoenaService(SubpoenaService subpoenaService) {
        this.subpoenaService = subpoenaService;
    }

    /**
     * @return 日結單代傳票 Service
     */
    public SubpoenaService getSubpoenaService() {
        return subpoenaService;
    }

    /**
     * @param 子系統別
     *            Service
     */
    public void setSysTypeService(SysTypeService sysTypeService) {
        this.sysTypeService = sysTypeService;
    }

    /**
     * @return 子系統別 Service
     */
    public SysTypeService getSysTypeService() {
        return sysTypeService;
    }

    /**
     * @param 送匯批次記錄Service
     */
    public void setPaymentBatchService(PaymentBatchService paymentBatchService) {
        this.paymentBatchService = paymentBatchService;
    }

    /**
     * @return 送匯批次記錄Service
     */
    public PaymentBatchService getPaymentBatchService() {
        return paymentBatchService;
    }

    /**
     * @param 流程簽核歷程
     *            Service
     */
    public void setFlowCheckstatusService(FlowCheckstatusService flowCheckstatusService) {
        this.flowCheckstatusService = flowCheckstatusService;
    }

    /**
     * @return 流程簽核歷程 Service
     */
    public FlowCheckstatusService getFlowCheckstatusService() {
        return flowCheckstatusService;
    }

    /**
     * @param 序號表
     *            Service
     */
    public void setSequenceService(SequenceService sequenceService) {
        this.sequenceService = sequenceService;
    }

    /**
     * @return 序號表 Service
     */
    public SequenceService getSequenceService() {
        return sequenceService;
    }

    /**
     * @param 使用者的
     *            Service
     */
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    /**
     * @return 使用者的 Service
     */
    public UserService getUserService() {
        return userService;
    }

    public void setTransitPaymentDetailService(TransitPaymentDetailService transitPaymentDetailService) {
        this.transitPaymentDetailService = transitPaymentDetailService;
    }

    public TransitPaymentDetailService getTransitPaymentDetailService() {
        return transitPaymentDetailService;
    }

    public void setEntryService(EntryService entryService) {
        this.entryService = entryService;
    }

    public EntryService getEntryService() {
        return entryService;
    }

    public BigTypeService getBigTypeService() {
        return bigTypeService;
    }

    public void setBigTypeService(BigTypeService bigTypeService) {
        this.bigTypeService = bigTypeService;
    }

    /**
     * @param 日計表 Service
     */
    public void setDailyStatementService(DailyStatementService dailyStatementService) {
        this.dailyStatementService = dailyStatementService;
    }

    /**
     * @return 日計表 Service
     */
    public DailyStatementService getDailyStatementService() {
        return dailyStatementService;
    }

}
