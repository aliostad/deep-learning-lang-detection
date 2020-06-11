package cn.gov.scciq.businessProgress.checkorReceive;
/**
 * 单证流程定义表
 * @author ada
 *
 */
public class ProcessDefineBean {
	
	private String processDefineID;
	private String processCode;
	private String processName;
	private String priorProcessCode;
	private String nextProcessCode;
	private String remarks;
	private String operatorFlg;
	private String cancelFlg;
	public String getProcessDefineID() {
		return processDefineID;
	}
	public void setProcessDefineID(String processDefineID) {
		this.processDefineID = processDefineID;
	}
	public String getProcessCode() {
		return processCode;
	}
	public void setProcessCode(String processCode) {
		this.processCode = processCode;
	}
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getPriorProcessCode() {
		return priorProcessCode;
	}
	public void setPriorProcessCode(String priorProcessCode) {
		this.priorProcessCode = priorProcessCode;
	}
	public String getNextProcessCode() {
		return nextProcessCode;
	}
	public void setNextProcessCode(String nextProcessCode) {
		this.nextProcessCode = nextProcessCode;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getOperatorFlg() {
		return operatorFlg;
	}
	public void setOperatorFlg(String operatorFlg) {
		this.operatorFlg = operatorFlg;
	}
	public String getCancelFlg() {
		return cancelFlg;
	}
	public void setCancelFlg(String cancelFlg) {
		this.cancelFlg = cancelFlg;
	}
	public ProcessDefineBean() {
		super();
	}
	

}
