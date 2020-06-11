package model;

import java.util.ArrayList;

/** 
 * @author M. C. Høj
 */

public abstract class Process {
	private int ProcessStep;
	private ProcessLine processLine;
	private ArrayList<ProcessLog> processLogs  = new ArrayList<ProcessLog>();

	public Process(int processStep, ProcessLine processLine) throws RuntimeException{
		if (processLine==null){
			throw new RuntimeException("processLine can't be set to null");
		} else {
			this.setProcessStep(processStep);
			this.processLine=processLine;
		}
	}

	public int getProcessStep(){
		return this.ProcessStep;
	}

	public void setProcessStep(int processStep)throws RuntimeException{
		if (processStep<0) {
			throw new RuntimeException("processStep can't be a negative number");
		} else {
			this.ProcessStep=processStep;
		}
	}

	public ProcessLine getProcessLine(){
		return this.processLine;
	}
	
	public ArrayList<ProcessLog> getProcessLogs(){
		return this.processLogs;
	}

	public void addProcessLog(ProcessLog processLog){
		this.processLogs.add(processLog);
		if (processLog.getProcess()!=this){
			processLog.setProcess(this);
		}
	}

	/**
     * always call this method trougth setProcess method in ProcessLog
     * @param intermediateProduct
     */
	public void removeProcessLog(ProcessLog processLog) throws RuntimeException{
		this.processLogs.remove(processLog);
	}

}
