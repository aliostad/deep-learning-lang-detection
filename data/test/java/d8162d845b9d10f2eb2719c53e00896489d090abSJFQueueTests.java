package com.logrit.simulator;

import static org.junit.Assert.*;

import org.junit.Test;

public class SJFQueueTests {
	
	@Test
	public void testTickTime() {

		ProcessQueue processes = new ProcessQueue();
		
		processes.addProcess(Process.makeProcess(8, 4), 0);
		processes.addProcess(Process.makeProcess(4, 2), 0);
		
		Queue queue = new SJFQueue(processes);
		
		queue.run();
		
		assertTrue(queue.running_time == 24);
	}
	
	@Test
	public void testTickTimeWithIdleTime() {

		ProcessQueue processes = new ProcessQueue();
		
		processes.addProcess(Process.makeProcess(8, 4), 0);
		processes.addProcess(Process.makeProcess(4, 2), 9);
		
		Queue queue = new SJFQueue(processes);
		
		queue.run();
		
		assertTrue(queue.running_time == 33);
	}
	
	@Test
	public void testTickTimeWithStarvation() {

		ProcessQueue processes = new ProcessQueue();
		
		processes.addProcess(Process.makeProcess(8, 4), 0);
		processes.addProcess(Process.makeProcess(4, 2), 0);
		processes.addProcess(Process.makeProcess(4, 2), 0);
		
		Queue queue = new SJFQueue(processes);
		
		queue.run();
		
		// If we make it out alive, we at least didn't get trapped by it
		//  Implementing a routine to detect starved processes is beyond the scope of this project
	}
}
