package com.iambookmaster.client.iphone.common;

import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.ui.Widget;

public class ClickHandlerPair {
	
	private ClickHandler handler;
	private Widget widget;
	
	/**
	 * @deprecated for serialization only
	 */
	public ClickHandlerPair() {
	}
	public ClickHandlerPair(ClickHandler handler, Widget widget) {
		this.handler = handler;
		this.widget = widget;
	}
	public ClickHandler getHandler() {
		return handler;
	}
	public Widget getWidget() {
		return widget;
	}  
	

}
