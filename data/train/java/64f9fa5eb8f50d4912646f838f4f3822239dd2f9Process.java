package com.girish.bpm.Entity;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author Girish.Yadav
 *
 */
@Entity
@Table(name = "PROCESSES_DEFINITION")
public class Process {
	@EmbeddedId
	private ProcessKey processKey;
	private String processDescription;
	private String processName;
	

	/*
	 * public static enum ProcessType{LINEAR,DYNAMIC}
	 * 
	 * @Enumerated(EnumType.STRING) private ProcessType processType;
	 */

	public String getProcessDescription() {
		return processDescription;
	}

	public void setProcessDescription(String processDescription) {
		this.processDescription = processDescription;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public ProcessKey getProcessKey() {
		return processKey;
	}

	public void setProcessKey(ProcessKey processKey) {
		this.processKey = processKey;
	}

	
	/*
	 * public ProcessType getProcessType() { return processType; }
	 * 
	 * public void setProcessType(ProcessType processType) { this.processType =
	 * processType; }
	 */

}
