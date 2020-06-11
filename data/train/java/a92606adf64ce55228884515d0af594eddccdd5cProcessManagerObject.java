package main.java.processmanager;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.BlockingQueue;

import main.java.JavaProcess;

public class ProcessManagerObject {

	private JavaProcess javaProcess;
	private JavaProcessThread processThread;
	

	public ProcessManagerObject(JavaProcess process) {
		this.javaProcess = process;
		// this.processThread=jpThread;
	}

	public void startThread(BlockingQueue<String[]> processQueue) {

		if(processThread==null){
			processThread = new JavaProcessThread(javaProcess.getPID(),
					processQueue, javaProcess);
		}
		if(!processThread.isAlive()){
			processThread.start();
		}
	}

	public boolean threadRunning() {

		return processThread.isAlive();
	}

	public void threadStop() {

		//processQueue.add("stop");
	}

	public String getPID() {
		return javaProcess.getPID();
	}

	public String getName() {
		return javaProcess.getName();
	}
	
	public JavaProcess getProcess(){
		return javaProcess;
	}
	public void clearObject(){
		javaProcess=null;
		processThread=null;
		
	}
}
