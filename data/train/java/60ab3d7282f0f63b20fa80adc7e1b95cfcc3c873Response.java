package org.uncertweb.ps.data;


public class Response {

	private String processIdentifier;
	private ProcessOutputs outputs;
	
	public Response(String processIdentifier) {
		this.processIdentifier = processIdentifier;
		this.outputs = new ProcessOutputs();
	}
	
	public Response(String processName, ProcessOutputs outputs) {
		this.processIdentifier = processName;
		this.outputs = outputs;
	}

	public String getProcessIdentifier() {
		return processIdentifier;
	}

	public ProcessOutputs getOutputs() {
		return outputs;
	}
	
}
