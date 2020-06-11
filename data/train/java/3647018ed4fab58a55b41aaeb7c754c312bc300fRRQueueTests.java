package com.logrit.simulator;

import static org.junit.Assert.*;

import org.junit.Test;

public class RRQueueTests {
	
	@Test
	public void testTickTime() {

		ProcessQueue processes = new ProcessQueue();
		
		Process p1 = Process.makeProcess(8, 4);
		Process p2 = Process.makeProcess(4, 2);

		processes.addProcess(p1, 0);
		processes.addProcess(p2, 0);
		
		Queue queue = new RRQueue(processes, 8);		
		queue.run();
		
		assertTrue(queue.running_time == 24);
		
		// Check the stats!
		for(ProcessStatistics p : ProcessStatistics.getAllStats()) {
			if(p.getProcess().equals(p1)) {
				double response_time = p.getResponseTime();
				double slowdown = p.getSlowDown(); 
				assertTrue(response_time == 8);
				assertTrue(slowdown == 1.5);
			}
		}
		
		double cpu_utilization = ProcessStatistics.getCPUUtilization();
		//assertTrue(cpu_utilization == 1);
	}
	
	@Test
	public void testTickTimeWithQuanta4() {

		ProcessQueue processes = new ProcessQueue();
		
		Process p1 = Process.makeProcess(8, 4);
		Process p2 = Process.makeProcess(4, 2);

		processes.addProcess(p1, 0);
		processes.addProcess(p2, 0);
		
		Queue queue = new RRQueue(processes, 4);		
		queue.run();
		
		assertTrue(queue.running_time == 28);
		
		// Check the stats!
		for(ProcessStatistics p : ProcessStatistics.getAllStats()) {
			if(p.getProcess().equals(p1)) {
				double response_time = p.getResponseTime();
				double slowdown = p.getSlowDown(); 
				assertTrue(response_time == 10);
				assertTrue(slowdown == 1.75);
			}
		}
		
		double cpu_utilization = ProcessStatistics.getCPUUtilization();
		//assertTrue(cpu_utilization == 1);
	}
	
	@Test
	public void testTickTimeWithContextSwitch() {
		Queue.CONTEXT_SWITCHING_TIME = 1;

		ProcessQueue processes = new ProcessQueue();
		
		Process p1 = Process.makeProcess(8, 4);
		Process p2 = Process.makeProcess(4, 2);

		processes.addProcess(p1, 0);
		processes.addProcess(p2, 0);
		
		Queue queue = new RRQueue(processes, 8);		
		queue.run();
		
		assertTrue(queue.running_time == 28);
		Queue.CONTEXT_SWITCHING_TIME = 0;
	}
}
