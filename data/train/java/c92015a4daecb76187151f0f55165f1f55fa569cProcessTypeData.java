package org.mifosplatform.billing.batchjobscheduling.data;

public class ProcessTypeData {

	
	private Long id;
	private String process;
	

	public String getProcess() {
		return process;
	}

	public void setProcess(String process) {
		this.process = process;
	}

	public ProcessTypeData() {
		// TODO Auto-generated constructor stub
	}
	
	public ProcessTypeData(final Long id, final String process){
		this.id = id;
		this.process = process;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	
}
