package lt.bumbis.rpsim.droolsjbpm;

import org.drools.event.process.ProcessCompletedEvent;
import org.drools.event.process.ProcessEventListener;
import org.drools.event.process.ProcessNodeLeftEvent;
import org.drools.event.process.ProcessNodeTriggeredEvent;
import org.drools.event.process.ProcessStartedEvent;
import org.drools.event.process.ProcessVariableChangedEvent;

public class EventListener implements ProcessEventListener {

	public void afterNodeLeft(ProcessNodeLeftEvent arg0) {
	}

	public void afterNodeTriggered(ProcessNodeTriggeredEvent arg0) {
	}

	public void afterProcessCompleted(ProcessCompletedEvent arg0) {
	}

	public void afterProcessStarted(ProcessStartedEvent arg0) {
	}

	public void afterVariableChanged(ProcessVariableChangedEvent arg0) {
	}

	public void beforeNodeLeft(ProcessNodeLeftEvent arg0) {
	}

	public void beforeNodeTriggered(ProcessNodeTriggeredEvent arg0) {
	}

	public void beforeProcessCompleted(ProcessCompletedEvent arg0) {
	}

	public void beforeProcessStarted(ProcessStartedEvent arg0) {
	}

	public void beforeVariableChanged(ProcessVariableChangedEvent arg0) {
	}
}
