package com.crimsonlogic.bpm;

import javax.ejb.Asynchronous;
import javax.ejb.Stateful;
import javax.ejb.Stateless;
import javax.inject.Inject;

import org.activiti.cdi.BusinessProcess;
import org.activiti.engine.RuntimeService;

import dtd._3a4r_purchaseorderrequest.Pip3A4PurchaseOrderRequest;
import dtd._3a8r_purchaseorderchangerequest.Pip3A8PurchaseOrderChangeRequest;

@Stateless
public class ProcessDog {
	@Inject
	private BusinessProcess businessProcess;
	@Inject
	private RuntimeService runtimeService;
//	@Inject
//	private Conversation conversation;

	@Asynchronous
	public void startProcess(ProcessVariable processVariable) {
//		conversation.begin();
		System.out.println("-------------Process begin------------");
		businessProcess.setVariable("processVariable", processVariable);
		System.out.println("-------------set process variables done------------");
		businessProcess.startProcessByKey("poManagementProcess");
		System.out.println("-------------Process started------------");
//		conversation.end();
	}
	
//	@Asynchronous
//	public void startProcess(Pip3A8PurchaseOrderChangeRequest poc) {
////		conversation.begin();
//		System.out.println("-------------Process begin------------");
//		businessProcess.setVariable("poc", poc);
//		businessProcess.startProcessByKey("poManagementProcess");
//		System.out.println("-------------Process started------------");
////		conversation.end();
//	}
}
