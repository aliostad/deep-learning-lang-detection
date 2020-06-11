package odu.edu.cs.ewichern.dispatcher;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import static org.junit.Assert.*;

import edu.odu.cs.ewichern.dispatcher.Process;
import edu.odu.cs.ewichern.dispatcher.ProcessQueue;

import static org.hamcrest.CoreMatchers.*;

/**
 * Unit tests for ProcessQueue Class
 * 
 * @author Erik Wichern
 */
public class ProcessQueueTest extends TestCase {

	private String name;
	private int priority;
	ProcessQueue pq;
	Process process, anotherProcess;

	private final int DEFAULT_PRIORITY = 2;

	protected void setUp() {
		name = "processName";
		priority = 1;
		pq = new ProcessQueue(priority);

		process = new Process(priority);
		anotherProcess = new Process(priority);
	}

	/**
	 * Create the test case
	 * 
	 * @param testName
	 *            name of the test case
	 */
	public ProcessQueueTest(String testName) {
		super(testName);
	}

	/**
	 * Run the suite of tests on this class
	 * 
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(ProcessQueueTest.class);
	}

	public void testConstructor() {
		pq = new ProcessQueue(priority);
		assertFalse(pq == null);
		assertEquals(priority, pq.getPriority());
	}

	public void testAddProcess() {
		boolean result = pq.addProcess(process);
		assertTrue(result);
		assertFalse(pq.isEmpty());
		assertEquals(1, pq.size());
		Process inserted = pq.getNextProcess();
		assertEquals(process, inserted);
		assertTrue(pq.isEmpty());
	}

	public void testRemoveProcess() {
		int processCount = 0;
		assertThat(process, not(equalTo(anotherProcess)));

		pq.addProcess(process);
		processCount++;
		pq.addProcess(anotherProcess);
		processCount++;

		assertFalse(pq.isEmpty());
		assertEquals(processCount, pq.size());

		boolean results = pq.removeProcess(process);
		processCount--;

		assertTrue(results);
		assertEquals(processCount, pq.size());

		// process was in first, should have been popped first;
		Process leftInQueue = pq.getNextProcess();
		assertThat(leftInQueue, not(equalTo(process)));
		assertEquals(anotherProcess, leftInQueue);
		assertTrue(pq.isEmpty());
	}

	public void testClearQueue() {
		int processCount = 0;

		pq.addProcess(process);
		processCount++;
		pq.addProcess(anotherProcess);
		processCount++;

		assertFalse(pq.isEmpty());
		assertEquals(processCount, pq.size());

		pq.clearQueue();

		Process leftInQueue = pq.getNextProcess();
		assertEquals(null, leftInQueue);

		assertTrue(pq.isEmpty());
	}

	public void testToArray() {
		int processCount = 0;

		pq.addProcess(process);
		processCount++;
		pq.addProcess(anotherProcess);
		processCount++;

		assertFalse(pq.isEmpty());
		assertEquals(processCount, pq.size());
		
		Object[] processArray = pq.toArray();
		assertEquals(pq.size(), processArray.length);
		
		int loc = 0;
		for (Process p : pq) {
			Process arrayElement = (Process) processArray[loc];
			assertEquals(p, arrayElement);
			loc++;
		}
	}
	
	public void testToString() {
		pq.addProcess(process);
		String actualOutput = pq.toString();
		String expectedOutput =
				"ProcessQueue [priority=" + priority + ", processQueue=[" + process + "]]";
		assertEquals(expectedOutput, actualOutput);
	}
}
