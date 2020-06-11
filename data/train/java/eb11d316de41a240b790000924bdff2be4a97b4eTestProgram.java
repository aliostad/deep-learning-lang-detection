package uebung11.aufgabe2;

import uebung11.aufgabe2.memoryManager.FirstFit;
import uebung11.aufgabe2.memoryManager.MemoryManager;
import uebung11.aufgabe2.processManager.Process;
import uebung11.aufgabe2.processManager.ProcessManager;

public class TestProgram {

	private static final int physicalMemorySize = 1024;

	private static ProcessManager pm;
	private static MemoryManager mmu;

	/**
	 * Test test-program does not reflect the real interaction between Processes and the memory Manager. However, it can
	 * be used to test different memory management strategies.
	 * 
	 * For simplicity, in this test-program every process receives its own continuous block of memory
	 */
	public static void main(String[] args) {
		mmu = new FirstFit(physicalMemorySize);
		pm = new ProcessManager(mmu);

		Process p1 = createProcess("p1", 100);
		Process p2 = createProcess("p2", 500);
		Process p3 = createProcess("p3", 60);
		Process p4 = createProcess("p4", 100);

		killProcess(p1);
		killProcess(p3);

		Process p5 = createProcess("p5", 50);
		Process p6 = createProcess("p6", 90);
	}

	/**
	 * This function just calls "process.kill()" and produces some nice output
	 */
	private static void killProcess(Process process) {
		String name = process.getName();
		boolean result = process.kill();
		if (true == result) {
			System.out.println("New Memory Partitioning after killing process: " + name);
			mmu.printAllProcesses();
		}
		System.out.println();
	}

	/**
	 * This function just calls "pm.createProcess(name, size)" and produces some nice output
	 */
	private static Process createProcess(String name, int size) {
		Process result;
		result = pm.createProcess(name, size);
		if (null != result) {
			System.out.println("New Memory Partitioning after starting process: " + name + " with size:" + size);
			mmu.printAllProcesses();
		}
		System.out.println();
		return result;
	}
}
