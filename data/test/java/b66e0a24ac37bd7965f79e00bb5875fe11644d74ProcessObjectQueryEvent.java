package com.viewfunction.vfbpm.adminCenter.UI.processManagement;

import com.github.wolfie.blackboard.Event;
import com.github.wolfie.blackboard.Listener;

public class ProcessObjectQueryEvent implements Event{
	
	private final String processSpaceName;
	private final String processType;
	private final int processStatus;
	
	
	public ProcessObjectQueryEvent(final String processSpaceName,final String processType,final int processStatus){
		this.processSpaceName=processSpaceName;
		this.processType=processType;
		this.processStatus=processStatus;
	}
	
	public String getProcessSpaceName() {
	    return this.processSpaceName;
	}
	
	public String getProcessType(){
		return this.processType;
	}
	
	public int getProcessStatus(){
		return this.processStatus;
	}
	
	public interface ProcessObjectQueryListener extends Listener {
	    public void receiveProcessObjectQuery(final ProcessObjectQueryEvent event);
	}
}