package pt.uc.dei.esper.event;

import java.io.Serializable;
import java.util.Date;

public class ProcessEvent implements Serializable {

	private static final long serialVersionUID = 1L;

	String machine;
	String processName;
	Date processStart;
	
	public ProcessEvent (String machine, String processName, Long processStart) {
		this.machine = machine;
		this.processName = processName;
		this.processStart = new Date(processStart);
	}
	
	public String getMachine () {
		return this.machine;
	}
	
	public String getProcessName () {
		return this.processName;
	}
	
	public Date getProcessStart () {
		return this.processStart;
	}
	
	@Override
	public String toString () {
		return "["+System.currentTimeMillis()+"] PROCESS "+this.processName+"@"+this.machine + " started " + this.processStart;
	}

}
