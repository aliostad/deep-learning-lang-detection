package generic.process.exec;

import generic.process.context.itf.InboundProcessInstanceCtx;
import generic.process.context.itf.OutboundProcessInstanceCtx;

public abstract class DynProcessHosting implements InboundProcessInstanceCtx {
	
	private OutboundProcessInstanceCtx outboundProcessInstanceCtx;
	
	

	public OutboundProcessInstanceCtx getOutboundProcessInstanceContext() {
		return outboundProcessInstanceCtx;
	}

	public void setOutboundProcessInstanceContext(
			OutboundProcessInstanceCtx outboundProcessInstanceContext) {
		this.outboundProcessInstanceCtx = outboundProcessInstanceContext;
	}

	
	
	public abstract void start();

}
