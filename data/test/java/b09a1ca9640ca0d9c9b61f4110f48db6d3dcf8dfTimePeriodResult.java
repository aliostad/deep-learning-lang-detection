package edu.cs.clemson.jymonte.dissertation.sim.process.result;

import java.util.ArrayList;
import java.util.List;

public class TimePeriodResult {
	List<ProcessResult> processResultList = new ArrayList<ProcessResult>();
	
	
	
	public void addProcessResult(ProcessResult pr) {
		processResultList.add(pr);
	}
	
	public ProcessResult get(int i) {
		ProcessResult prReturnValue = null;
		if(i < processResultList.size())
			prReturnValue = processResultList.get(i);
		return prReturnValue;
	}

	public int size() {
		return processResultList.size();
	}
}
