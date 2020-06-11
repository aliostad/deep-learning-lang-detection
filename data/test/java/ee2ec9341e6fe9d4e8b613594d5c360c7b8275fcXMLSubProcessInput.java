package org.processbase.ui.core.bonita.forms.subprocess;

public class XMLSubProcessInput {
	
	public XMLSubProcessInput(String subProcessTarget){
		this.subProcessTarget= subProcessTarget;
	}
	
	private String processSource;
	private String subProcessTarget;
	public void setProcessSource(String processSource) {
		this.processSource = processSource;
	}
	public String getProcessSource() {
		return processSource;
	}
	public void setSubProcessTarget(String subProcessTarget) {
		this.subProcessTarget = subProcessTarget;
	}
	public String getSubProcessTarget() {
		return subProcessTarget;
	}
}