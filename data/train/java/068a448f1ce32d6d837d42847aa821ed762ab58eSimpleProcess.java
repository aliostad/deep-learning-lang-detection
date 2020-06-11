package org.dhananjay.siprotrack;

import java.util.HashMap;
import java.util.Map;

import org.dhananjay.siprotrack.impl.SimpleProcessTracker;

/**
 * @author dhananjayp
 *
 */
public class SimpleProcess {
	
	private SimpleProcessTracker simpleProcessTracker;

	private ChildProcess childProcess;
	
	public void initProcess(){
		//simpleProcessTracker = new SimpleProcessTracker();
		simpleProcessTracker.startProcess("My Simple Process");
		System.out.println("Init of Simple Process");
		stepOne();
		simpleProcessTracker.endProcess();
	}
	
	public void stepOne(){
		Map<String, String> map = new HashMap<String, String>();
		map.put("PARAM1", "Dhananjay");
		simpleProcessTracker.saveProcess("STEP1",map);
		System.out.println("Init of Step One of Simple Process");
		//childProcess = new ChildProcess();
		childProcess.childStepOne();
		childProcess.childStepTwo();
		
	}

	public void setSimpleProcessTracker(SimpleProcessTracker simpleProcessTracker) {
		this.simpleProcessTracker = simpleProcessTracker;
	}

	public void setChildProcess(ChildProcess childProcess) {
		this.childProcess = childProcess;
	}
	
	
	/*public static void main(String[] args) {
		SimpleProcess process = new SimpleProcess();
		process.initProcess();
	}*/
}