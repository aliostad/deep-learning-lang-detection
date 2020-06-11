/**
 * 
 */
package com.galaxy.merchant.simulator.context;

import org.apache.log4j.Logger;

/**
 * @author Ranjan Kumar
 * @date 2015-03-23
 *
 */
public class Context {

	private static final Logger log = Logger.getLogger(Context.class);

	private boolean status;
	private int processId;
	private String processDesc;

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	public int getProcessId() {
		return processId;
	}

	public void setProcessId(int processId) {
		this.processId = processId;
	}

	public String getProcessDesc() {
		return processDesc;
	}

	public void setProcessDesc(String processDesc) {
		this.processDesc = processDesc;
	}

	@Override
	public String toString() {
		return "CabContext [status=" + status + ", processId=" + processId
				+ "]";
	}

}
