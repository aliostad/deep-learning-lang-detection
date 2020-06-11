package os.processes;

import java.util.LinkedList;

import machine.CPU;
import os.OS;
import os.OS.ResourceName;
import os.Process;
import os.OS.ProcessName;
import os.OS.ProcessState;

public class MainProc extends Process {
	public MainProc(int inID, ProcessName outID, LinkedList<Process> processList,
			 		Process parentProcess, CPU cpu, OS os, ProcessState processState,
			 		int processPriority) {
		super(inID, outID, processList, parentProcess, cpu, os, processState, processPriority);
	}
	// process steps
	@Override
	public void step() {
		switch (nextInstruction) {
		case 1:
			processDescriptor.os.requestResource(this, ResourceName.UZDUOTIS_ISORINEJE_ATMINTYJE);
			nextInstruction++;
		    break;
		case 2:
			checkGovernors();
			if (processDescriptor.ownedResourceList.size() != 0) {
				if (processDescriptor.ownedResourceList.getLast().resourceDescriptor.getCreatorProcess().processDescriptor.outID == ProcessName.WAIT_FOR_JOB) {
					processDescriptor.os.createProcess(this, ProcessName.JOB_GOVERNOR);
				}
				else {
					processDescriptor.os.destroyResource(processDescriptor.ownedResourceList.getFirst());
				}
			}
			nextInstruction = 1;
			break; 
		}
    }
	// checks if created processes (JobGovernors) are halted or not
	public void checkGovernors() {
		JobGovernor governorProcess;
		for (Process process : processDescriptor.childrenProcessList) {
			governorProcess = (JobGovernor) process;
			if (governorProcess.isJobHalted) {
				processDescriptor.os.destroyProcess(process);
			}
		}
	}
}
