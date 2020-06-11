package com.cowlabs.games.framework.process;

import java.util.Iterator;
import java.util.Vector;

public class ProcessManager {

	private Vector<Process> processes = new Vector<Process>();
	private Vector<Process> toAttach = new Vector<Process>();
	
	public void attach(Process newProcess){
		this.toAttach.add(newProcess);
	}
	
	public void updateProcesses(float deltaTime){
		
		this.processes.addAll(this.toAttach);
		
		Iterator<Process> i = processes.iterator();
		Process process;
		
		while(i.hasNext()){
			process = i.next();
			
			process.onUpdate(deltaTime);
			
			if(process.isDead()){
				i.remove();
				if((process = process.getNext()) != null){
					this.attach(process);
				}
			}
		}
	}
	
	

}
