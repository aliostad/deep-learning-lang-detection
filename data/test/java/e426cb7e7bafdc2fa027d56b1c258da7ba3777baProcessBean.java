package com.mmonit.bean;

import java.io.Serializable;

public class ProcessBean implements Serializable {

	/**
	 * Monit Process Status And Resourse status
	 * monit type:3
	 */
	private static final long serialVersionUID = 1L;

	/*process id*/
	private int process_id;

	/*muti process to one monitbean*/
	private MonitBean monitBean;
	
	/*process collected_sec*/
	private String collected_sec;
	
	/*collected_usec*/
	private String collected_usec;

	/*process name muti one monit to mult processes*/
	private String processName;
	
	/*process status 0 stand alive*/
	private int processStatus;
	
	/*process status_message*/
	private String processStatusMessage;
	
	/*process pid*/
	private String processPid;
	
	/*process Uptime*/
	private String processUptime;
	
	/*process children*/
	private int processChildren;
	
	/*process memPercenttotal*/
	private float processMemPercenttotal;
	
	/*process memKilobytetotal*/
	private int processMemKilobytetotal;
	
	/*process cpuPercenttotal*/
	private float processCpuPercenttotal;
	
	/*process monitId*/
	private String monitId;
	
	public int getProcess_id() {
		return process_id;
	}

	public void setProcess_id(int process_id) {
		this.process_id = process_id;
	}

	public MonitBean getMonitBean() {
		return monitBean;
	}

	public void setMonitBean(MonitBean monitBean) {
		this.monitBean = monitBean;
	}
	
	public ProcessBean() {
		super();
	}	
	
	public String getCollected_sec() {
		return collected_sec;
	}

	public void setCollected_sec(String collected_sec) {
		this.collected_sec = collected_sec;
	}

	public String getCollected_usec() {
		return collected_usec;
	}

	public void setCollected_usec(String collected_usec) {
		this.collected_usec = collected_usec;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public int getProcessStatus() {
		return processStatus;
	}

	public void setProcessStatus(int processStatus) {
		this.processStatus = processStatus;
	}

	public String getProcessStatusMessage() {
		return processStatusMessage;
	}

	public void setProcessStatusMessage(String processStatusMessage) {
		this.processStatusMessage = processStatusMessage;
	}

	public String getProcessPid() {
		return processPid;
	}

	public void setProcessPid(String processPid) {
		this.processPid = processPid;
	}

	public String getProcessUptime() {
		return processUptime;
	}

	public void setProcessUptime(String processUptime) {
		this.processUptime = processUptime;
	}

	public int getProcessChildren() {
		return processChildren;
	}

	public void setProcessChildren(int processChildren) {
		this.processChildren = processChildren;
	}

	public float getProcessMemPercenttotal() {
		return processMemPercenttotal;
	}

	public void setProcessMemPercenttotal(float processMemPercenttotal) {
		this.processMemPercenttotal = processMemPercenttotal;
	}

	public int getProcessMemKilobytetotal() {
		return processMemKilobytetotal;
	}

	public void setProcessMemKilobytetotal(int processMemKilobytetotal) {
		this.processMemKilobytetotal = processMemKilobytetotal;
	}

	public float getProcessCpuPercenttotal() {
		return processCpuPercenttotal;
	}

	public void setProcessCpuPercenttotal(float processCpuPercenttotal) {
		this.processCpuPercenttotal = processCpuPercenttotal;
	}

	public String getMonitId() {
		return monitId;
	}

	public void setMonitId(String monitId) {
		this.monitId = monitId;
	}
	
}
