package com.aol.assignments.addresscache.handler;

/**
 * a convenience for composing method handler chains (is simpler constructor handler nesting)
 * @author paul
 *
 */
public class HandlerChainBuilder {

	/**
	 * the head handler (returned by build)
	 */
	private AbstractTaskHandler head;
	
	/**
	 * the most recently-added handler, required for chain-wiring
	 */
	private AbstractTaskHandler last;
	
	/**
	 * adds a handler to the building chain
	 * 
	 * @param handler a method handler
	 * @return this
	 */
	public HandlerChainBuilder add(final AbstractTaskHandler handler) {
		if (head == null) {
			head = last = handler;
		} else {
			last.nextHandler = handler;
			last = handler;
		}
		
		return this;
	}
	
	/**
	 * returns the head link in the chain
	 * 
	 * @return the head link in the chain
	 */
	public AbstractTaskHandler build() {
		return head;
	}
}
