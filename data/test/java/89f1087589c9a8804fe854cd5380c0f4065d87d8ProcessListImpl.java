/*
 * Created on Aug 26, 2004
 */
package impl.owls.process;


import impl.owl.CastingList;

import java.net.URI;

import org.mindswap.owl.OWLIndividualList;
import org.mindswap.owls.process.Process;
import org.mindswap.owls.process.ProcessList;

/**
 * @author Evren Sirin
 */
public class ProcessListImpl extends CastingList implements ProcessList {
    public ProcessListImpl() {
        super(Process.class);
    }

    public ProcessListImpl(OWLIndividualList list) {
        super(list, Process.class);
    }
    
    public Process processAt(int index) {
		return (Process) get(index);
	}

	public Process getProcess(URI processURI) {
		return (Process) getIndividual(processURI);
	}

}
