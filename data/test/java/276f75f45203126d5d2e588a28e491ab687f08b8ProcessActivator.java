package com.prosoft.vhdl.sim;

import java.util.ArrayList;

import com.prosoft.vhdl.ir.IRElement;

public abstract class ProcessActivator extends SimulationObject {
	
	ArrayList<Process> listeners;

	protected ProcessActivator(Simulator sim, IRElement desc) {
		super(sim, desc);
	}

	void addProcess( Process process ) {
		if( listeners == null ) listeners = new ArrayList<Process>();
		listeners.add(process);
	}
	
	void removeProcess( Process process ) {
		listeners.remove(process);
	}
	
	protected void activateListeners() {
		for( int i = 0; i < listeners.size(); i++ ) {
			listeners.get(i).activate();
		}
	}
}
