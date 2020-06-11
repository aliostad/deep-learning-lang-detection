package cn.edu.pku.ss.matchmaker.util;

import java.util.List;

import EDU.cmu.Atlas.owls1_1.process.CompositeProcess;
import EDU.cmu.Atlas.owls1_1.process.ControlConstruct;
import EDU.cmu.Atlas.owls1_1.process.ControlConstructList;
import EDU.cmu.Atlas.owls1_1.process.Perform;
import EDU.cmu.Atlas.owls1_1.process.Process;
import EDU.cmu.Atlas.owls1_1.process.implementation.IfThenElseImpl;
import EDU.cmu.Atlas.owls1_1.process.implementation.RepeatWhileImpl;

public class AtomicProcessExtractor {
	
	public static List<Process> getAtomics(Process process, List<Process> atomics) {
		if (process == null) {
			return null;
		}
		
		
		if (process.isAtomic() || process.isSimple()) {
			atomics.add(process);
			return atomics;
		}
		
		CompositeProcess compositeProcess = (CompositeProcess) process;
		ControlConstruct comp = compositeProcess.getComposedOf();
		
		if (comp instanceof IfThenElseImpl) {
			ControlConstruct  thenConstruct = ((IfThenElseImpl)comp).getThen();
			ControlConstruct elseConstruct = ((IfThenElseImpl)comp).getElse();
			if(thenConstruct != null) {
				Process tmpProcess = ((Perform)thenConstruct).getProcess();
				getAtomics(tmpProcess, atomics);
			}
			
			if (elseConstruct != null) {
				Process tmpProcess = ((Perform)elseConstruct).getProcess();
				getAtomics(tmpProcess, atomics);
			}
			
		} else if(comp instanceof RepeatWhileImpl) {
			ControlConstruct whileConstruct = ((RepeatWhileImpl)comp).getWhileProcess();
			if (whileConstruct != null) {
				Process tmpProcess = ((Perform)whileConstruct).getProcess();
				getAtomics(tmpProcess, atomics);
			}
		
		} else {
			ControlConstructList components = (ControlConstructList)comp.getComponents();
			while(components != null) {
				Process tmpProcess = ((Perform)components.getFirst()).getProcess();
				getAtomics(tmpProcess, atomics);
				components = (ControlConstructList) components.getRest();
			}
		}
		
		return atomics;
	}

}
