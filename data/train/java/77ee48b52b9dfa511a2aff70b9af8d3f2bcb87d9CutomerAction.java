package com.redhat.brmsdemo.action;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.drools.runtime.process.ProcessInstance;

import com.redhat.brmsdemo.bean.Process;
import com.redhat.brmsdemo.brms.EngineManager;
import com.redhat.brmsdemo.model.Customer;

@Named("customerAction")
@ApplicationScoped
public class CutomerAction {
	
	private static final String CREDIT_PROCESS_ID = "redhat.CreditProcess";

	@Inject private EngineManager engineManager;
	
	private String processId;
	private List<Process> processes;
	private Customer customer = new Customer();

	
	public List<Process> getProcesses() throws Exception {
		Collection<ProcessInstance> processInstances = engineManager.getProcessInstances();
		processes = new ArrayList<Process>();
		for (ProcessInstance instance : processInstances) {
			Process process = new Process();
			process.setProcessId(instance.getProcessId());
			process.setInstanceId(instance.getId());
			process.setStatus(instance.getState());
			processes.add(process);
		}
		return processes; 
	}

	public String createProposal() throws Exception {
		customer.setApproved(true);
		customer.setCreditValue(0);
		engineManager.insertFact(customer);
		Map<String, Object> processVariables = new HashMap<String, Object>();
		processVariables.put("customer", customer);
		engineManager.startProcess(CREDIT_PROCESS_ID, processVariables);
		return "process?faces-redirect=true?";
	}
	

	public String getProcessId() {
		return processId;
	}

	public void setProcessId(String processId) {
		this.processId = processId;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
}
