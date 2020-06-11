package org.stringtree.xml;

import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

public class XMLProcessorContext {
	private Map<String,TagHandler> handlers = null;
	private Writer out;
	
	public XMLProcessorContext(Writer out) {
		this.out = out;
	}
	
	public void setHandlers(Map<String,TagHandler> handlers) {
		this.handlers = handlers;
	}
	
	public void setHandler(String name, TagHandler handler) {
		if (handlers == null) {
			handlers = new HashMap<String,TagHandler>();
		}
		
		handlers.put(name, handler);
	}
	
	public void addHandler(TagHandler handler) {
		setHandler(handler.getName(), handler);
	}
	
	public void removeHandler(TagHandler handler) {
		setHandler(handler.getName(), null);
	}
	
	public void setDefaultHandler(TagHandler handler) {
		setHandler("/", handler);
	}
	
	public TagHandler getHandler(String name) {
		return handlers != null ? (TagHandler)handlers.get(name) : null;
	}
	
	public TagHandler getDefaultHandler() {
		return getHandler("/");
	}
	
	public Writer getWriter() {
		return out;
	}
}