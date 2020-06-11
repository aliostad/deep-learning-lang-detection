package Procesai;

import java.util.ArrayList;
import java.util.List;

import os.Statiniai;

public class PL {
	
	public static List<ProcessListElement> processList = new ArrayList<ProcessListElement>();
	
	public static void initialise() {
		processList.add(new ProcessListElement(Statiniai.Pstring.BeginEnd));
		processList.add(new ProcessListElement(Statiniai.Pstring.IInterrupt));
		processList.add(new ProcessListElement(Statiniai.Pstring.InputStream));
		processList.add(new ProcessListElement(Statiniai.Pstring.SyntaxCheck));
		processList.add(new ProcessListElement(Statiniai.Pstring.Loader));
		processList.add(new ProcessListElement(Statiniai.Pstring.Destroyer));
		processList.add(new ProcessListElement(Statiniai.Pstring.Interrupt));
		processList.add(new ProcessListElement(Statiniai.Pstring.Swapper));
		processList.add(new ProcessListElement(Statiniai.Pstring.Writer));
		processList.add(new ProcessListElement(Statiniai.Pstring.MainGovernor));
		processList.add(new ProcessListElement(Statiniai.Pstring.JobGovernor));
		processList.add(new ProcessListElement(Statiniai.Pstring.VirtualMachine));
		processList.add(new ProcessListElement(Statiniai.Pstring.Input));
		processList.add(new ProcessListElement(Statiniai.Pstring.Idle));
		
	}
	
	public static void addProcess(ProcessBase p) {
		for (int i = 0; i < processList.size(); i++) {
			if (p.nameO == processList.get(i).name) {
				processList.get(i).processList.add(p);
				return;
			}
		}
	}
	
	public static ProcessBase getProcess(int innerName) {
		for (int i = 0; i < processList.size(); i++) {
			for (int j = 0; j < processList.get(i).processList.size(); j++) {
				if (processList.get(i).processList.get(j).nameI == innerName) {
					return processList.get(i).processList.get(j);
				}
			}
		}
		return null;
		
	}
}
