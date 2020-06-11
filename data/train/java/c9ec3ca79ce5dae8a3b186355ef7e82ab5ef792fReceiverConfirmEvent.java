package event;

import model.CustomProcess;
import net.sf.appia.core.events.SendableEvent;

/**
 * Print request confirmation event.
 * 
 * @author akt & kcg
 */
public class ReceiverConfirmEvent extends SendableEvent {
	static int rqid;
	private CustomProcess processDest;
	private CustomProcess processSource;

	public CustomProcess getProcessDest() {
		return processDest;
	}

	public CustomProcess getProcessSource() {
		return processSource;
	}

	public void setId(int rid) {
		rqid = rid;
	}

	public int getId() {
		return rqid;
	}

	public void setDest(CustomProcess customProcess) {
		this.processDest = customProcess;

		dest = customProcess.getCompleteAddress();
	}

	public void setSendSource(CustomProcess customProcess) {
		this.processSource = customProcess;

		source = customProcess.getCompleteAddress();
	}
}
