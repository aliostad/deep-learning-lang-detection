package event;

import model.CustomProcess;
import net.sf.appia.core.events.SendableEvent;


/**
 * Print request confirmation event.
 * 
 * @author akt & kcg
 */
public class DeliverEvent extends SendableEvent {
	private CustomProcess processDest;
	private CustomProcess processSource;

	public CustomProcess getDestProcess() {
		return processDest;
	}
	
	public CustomProcess getSourceProcess() {
		return processSource;
	}

	public void setDestProcess(CustomProcess process) {
		this.processDest = process;
		
		dest = process.getCompleteAddress();
	}
	
	public void setSourceProcess(CustomProcess process) {
		this.processSource = process;
		
		source = process.getCompleteAddress();
	}

}
