package org.dhananjay.siprotrack;

import java.util.HashMap;
import java.util.Map;

/**
 * @author dhananjayp
 *
 */
public class ChildProcess {

	private ProcessTracker processTracker;
	
	public ProcessTracker getProcessTracker() {
		return processTracker;
	}


	public void setProcessTracker(ProcessTracker processTracker) {
		this.processTracker = processTracker;
	}


	public void childStepOne(){
		Map<String, String> map = new HashMap<String, String>();
		map.put("PARAM1", "Dhananjay1");
		processTracker.saveProcess("Chile STEP1",map);
		System.out.println("Child Process Step One");
	}
	
	
	public void childStepTwo(){
		System.out.println("Child Process Step Two");
		Map<String, String> map = new HashMap<String, String>();
		map.put("PARAM2", "Dhananjay1");
		processTracker.saveProcess("Chile STEP2",map);
	}
}
