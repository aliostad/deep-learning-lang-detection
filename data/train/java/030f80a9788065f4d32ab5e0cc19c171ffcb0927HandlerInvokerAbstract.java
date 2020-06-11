package service.invoker;

import com.aliapp.wxxd.material.entity.InputMessage;
import com.aliapp.wxxd.material.entity.outputmessage.OutputMessageAbstract;

import service.AbstractHandler;

public abstract class HandlerInvokerAbstract {
	protected AbstractHandler handler;

	/**
	 * 
	 */
	public HandlerInvokerAbstract() {
		super();
	}

	/**
	 * @param handler
	 */
	public HandlerInvokerAbstract(AbstractHandler handler) {
		super();
		this.handler = handler;
	}

	public AbstractHandler getHandler() {
		return handler;
	}

	public void setHandler(AbstractHandler handler) {
		this.handler = handler;
	}

	public abstract OutputMessageAbstract handle(InputMessage im);
}
