package org.testobject.commons.util.process;


/**
 * 
 * @author enijkamp
 *
 */
public interface ProcessInspector
{
	interface Process
	{
		int getPid();

		String getName();

		Process[] getChildren();

		int getVirtualMemoryConsumption();
		
		float getCpuUsage();
		
		void suspend();
		
		void resume();

	}
	
	int getCurrentProcess();

	Process[] getProcesses();

	Process getProcessTree();

	Process getProcess(int pid);

	Process getProcess(java.lang.Process process);
	
	int getProcessPid(java.lang.Process process);
	
	float getCpuUsage();

	void killHard(java.lang.Process process);

}
