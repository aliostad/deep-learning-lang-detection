package ir.utopia.core.process;

import java.io.Serializable;

public class BeanProcess implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3125043981966073898L;
	String processName;
	BeanProcessParameter[]params;
	public BeanProcess(String processName){
		this.processName=processName;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public BeanProcessParameter[] getParameters() {
		return params;
	}

	public void setParameters(BeanProcessParameter[] params) {
		this.params = params;
	}
	
}
