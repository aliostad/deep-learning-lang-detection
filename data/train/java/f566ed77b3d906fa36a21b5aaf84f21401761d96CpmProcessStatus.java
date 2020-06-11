package org.infosec.ismp.manager.rmi.snmp.model.cisco;

import java.io.Serializable;


/**
 * @author guoxianwei
 * @date 2010-10-20 上午10:52:01
 * 
 */
public class CpmProcessStatus implements Serializable {

	private static final long serialVersionUID = -993588298196945409L;

	public CpmProcessStatus() {
	}

	private String cpmProcessPID;
	private String cpmProcessName;
	private String cpmProcessuSecs;
	private String cpmProcessTimeCreated;
	private String cpmProcessAverageUSecs;
	// CpmProcessStatus的扩展

	private CpmProcessExtStatus cpmProcessExtStatus;

	private CpmProcessExtRevStatus cpmProcessExtRevStatus;

	public CpmProcessExtRevStatus getCpmProcessExtRevStatus() {
		return cpmProcessExtRevStatus;
	}

	public void setCpmProcessExtRevStatus(
			CpmProcessExtRevStatus cpmProcessExtRevStatus) {
		this.cpmProcessExtRevStatus = cpmProcessExtRevStatus;
	}

	public CpmProcessExtStatus getCpmProcessExtStatus() {
		return cpmProcessExtStatus;
	}

	public void setCpmProcessExtStatus(CpmProcessExtStatus cpmProcessExtStatus) {
		this.cpmProcessExtStatus = cpmProcessExtStatus;
	}

	public String getCpmProcessPID() {
		return cpmProcessPID;
	}

	public String getCpmProcessName() {
		return cpmProcessName;
	}

	public String getCpmProcessuSecs() {
		return cpmProcessuSecs;
	}

	public String getCpmProcessTimeCreated() {
		return cpmProcessTimeCreated;
	}

	public String getCpmProcessAverageUSecs() {
		return cpmProcessAverageUSecs;
	}

	public void setCpmProcessPID(String cpmProcessPID) {
		this.cpmProcessPID = cpmProcessPID;
	}

	public void setCpmProcessName(String cpmProcessName) {
		this.cpmProcessName = cpmProcessName;
	}

	public void setCpmProcessuSecs(String cpmProcessuSecs) {
		this.cpmProcessuSecs = cpmProcessuSecs;
	}

	public void setCpmProcessTimeCreated(String cpmProcessTimeCreated) {
		this.cpmProcessTimeCreated = cpmProcessTimeCreated;
	}

	public void setCpmProcessAverageUSecs(String cpmProcessAverageUSecs) {
		this.cpmProcessAverageUSecs = cpmProcessAverageUSecs;
	}

}


