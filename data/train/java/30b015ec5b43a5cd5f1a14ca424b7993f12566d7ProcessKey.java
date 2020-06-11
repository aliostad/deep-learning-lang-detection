package com.girish.bpm.Entity;

import java.io.Serializable;

import javax.persistence.Embeddable;

/**
 * @author Girish.Yadav
 *
 */
@Embeddable
public class ProcessKey implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3682324973136826271L;
	private int processId;
	private String processVersion="1.0";
	public String getProcessVersion() {
		return processVersion;
	}

	public void setProcessVersion(String processVersion) {
		this.processVersion = processVersion;
	}

	public int getProcessId() {
		return processId;
	}

	public void setProcessId(int processId) {
		this.processId = processId;
	}


}
