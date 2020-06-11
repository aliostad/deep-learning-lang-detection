package ag.processmonitor.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ag.processmonitor.models.SystemProcess;
import ag.processmonitor.services.ProcessReceivable;

@Service
public class SystemProcessProvider {
	
	private final ProcessReceivable processReceiver;
	
	@Autowired
	public SystemProcessProvider(ProcessReceivable processReceiver) {
		this.processReceiver = processReceiver;
	}

	public List<SystemProcess> processList() {
		return processReceiver.listProcess();
	}
}
