package org.kermeta.spem.processexecution.model;

import org.kermeta.spem.processexecution.model.SPEMDeliveryProcess;

public class Tree {
	
	private String name;
	private SPEMDeliveryProcess[] spemDeliveryProcess;
	
	public Tree(String name, SPEMDeliveryProcess[] spemDeliveryProcess) {
		this.name = name;
		this.spemDeliveryProcess = spemDeliveryProcess;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public SPEMDeliveryProcess[] getSpemDeliveryProcess() {
		return spemDeliveryProcess;
	}

	public void setSpemDeliveryProcess(SPEMDeliveryProcess[] spemDeliveryProcess) {
		this.spemDeliveryProcess = spemDeliveryProcess;
	}

}
