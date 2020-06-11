package cpu;

import java.util.Date;

public class Cpu {

	
	/*
	 * variable to store current process for execution
	 * */
	private Process process;
	
	public Cpu(){
		
	}
	
	/*
	 * execute method will decrement process run time by 0.1 seconde
	 * */
	private void execute(){
		process.decrementProcessRunTime();
		System.out.println("cpu executing process");
	}
	
	/*
	 * scheduler will call this method to put a process on the cpu for 
	 * execution
	 * */
	public void setCpuProcess(Process process){
		Date date = new Date();
		
		this.process = process;
		//stamp process with current time stamp
		process.setLastRan(date.getTime());
		System.out.println("cpu has processes " + process);
		execute();
	}
	
	/*
	 * scheduler will call this method to take a process from the cpu
	 * */
	public Process getCpuProcess(){
		return process;
	}
	
}
