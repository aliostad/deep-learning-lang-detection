package os.processes;

import java.util.LinkedList;

import machine.CPU;
import machine.Machine;
import os.OS;
import os.OS.ProcessName;
import os.OS.ProcessState;
import os.OS.ResourceName;
import os.Process;

public class PrintLine extends Process {
	String message;
	ProcessName creatorOutID;
	int creatorInID;
	
	public PrintLine(int inID, ProcessName outID, LinkedList<Process> processList,
					 Process parentProcess, CPU cpu, OS os, ProcessState processState,
					 int processPriority) {
		super(inID, outID, processList, parentProcess, cpu, os, processState, processPriority);
	}
	// process steps
	@Override
	public void step() {
		switch (nextInstruction) {
		case 1:
			processDescriptor.os.requestResource(this, ResourceName.PRANESIMAS_PRINTLINE);
			nextInstruction++;
			break;
		case 2:
			message = (String) processDescriptor.ownedResourceList.getLast().getComponent();
			creatorOutID = processDescriptor.ownedResourceList.getLast().resourceDescriptor.getCreatorProcess().processDescriptor.outID;
			creatorInID = processDescriptor.ownedResourceList.getLast().resourceDescriptor.getCreatorProcess().processDescriptor.inID;
			processDescriptor.os.requestResource(this, ResourceName.ISVEDIMO_IRENGINYS);
			nextInstruction++;
			break;
		case 3:
			processDescriptor.os.destroyResource(processDescriptor.ownedResourceList.getFirst());
			Machine.outputArea.append("USER: " + message + "\n");
			nextInstruction++;
			break;
		case 4:
			processDescriptor.os.releaseResource(processDescriptor.ownedResourceList.getLast());
			if (creatorOutID == ProcessName.JOB_GOVERNOR) {
				processDescriptor.os.createResource(this, ResourceName.ISVESTA_EILUTE_JOB, creatorInID);
			}
			else {
				processDescriptor.os.createResource(this, ResourceName.ISVESTA_EILUTE, null);
			}
			nextInstruction = 1;
			break;
		}
	}
}
