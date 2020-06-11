package event;

import model.CustomProcess;
import net.sf.appia.core.events.SendableEvent;


/**
 * Print request event.
 * 
 * @author akt & kcg
 */
public class SendEvent extends SendableEvent {
	private CustomProcess processDest;
	private CustomProcess processSource;
	private boolean original;
	
	public void isOriginalMessage(boolean original){
		this.original = original;
	}
	
	public boolean isOriginalMessage(){
		return original;
	}

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
