package cn.gov.scciq.businessProgress.checkorReceive;
/**
 * 单证流程表
 * @author ada
 *
 */
public class ProcessStepBean {
	
	private String  processStepID;
	private String 	declNo;
	private String 	processCode;
	private String 	processOrgCode;
	private String 	processDeptCode;
	private String 	processOperatorCode;
	private String 	processOperateDatetime;
	private String 	remarks;
	private String 	nextProcessCode;
	private String 	nextProcessOrgCode;
	private String 	nextProcessDeptCode;
	private String 	nextProcessOperator;
	public ProcessStepBean() {
		super();
	}
	public String getProcessStepID() {
		return processStepID;
	}
	public void setProcessStepID(String processStepID) {
		this.processStepID = processStepID;
	}
	public String getDeclNo() {
		return declNo;
	}
	public void setDeclNo(String declNo) {
		this.declNo = declNo;
	}
	public String getProcessCode() {
		return processCode;
	}
	public void setProcessCode(String processCode) {
		this.processCode = processCode;
	}
	public String getProcessOrgCode() {
		return processOrgCode;
	}
	public void setProcessOrgCode(String processOrgCode) {
		this.processOrgCode = processOrgCode;
	}
	public String getProcessDeptCode() {
		return processDeptCode;
	}
	public void setProcessDeptCode(String processDeptCode) {
		this.processDeptCode = processDeptCode;
	}
	public String getProcessOperatorCode() {
		return processOperatorCode;
	}
	public void setProcessOperatorCode(String processOperatorCode) {
		this.processOperatorCode = processOperatorCode;
	}
	public String getProcessOperateDatetime() {
		return processOperateDatetime;
	}
	public void setProcessOperateDatetime(String processOperateDatetime) {
		this.processOperateDatetime = processOperateDatetime;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getNextProcessCode() {
		return nextProcessCode;
	}
	public void setNextProcessCode(String nextProcessCode) {
		this.nextProcessCode = nextProcessCode;
	}
	public String getNextProcessOrgCode() {
		return nextProcessOrgCode;
	}
	public void setNextProcessOrgCode(String nextProcessOrgCode) {
		this.nextProcessOrgCode = nextProcessOrgCode;
	}
	public String getNextProcessDeptCode() {
		return nextProcessDeptCode;
	}
	public void setNextProcessDeptCode(String nextProcessDeptCode) {
		this.nextProcessDeptCode = nextProcessDeptCode;
	}
	public String getNextProcessOperator() {
		return nextProcessOperator;
	}
	public void setNextProcessOperator(String nextProcessOperator) {
		this.nextProcessOperator = nextProcessOperator;
	}
	
	

}
