package com.jstrgames.tetris.core.controller.rotate;

import com.jstrgames.tetris.core.model.Coordinate;

public class RotateProcessor {
	private IRotateHandler handler;
	
	public RotateProcessor(IRotateHandler handler) {
		this.handler = handler;
	}
	
	/**
	 * works like a stack by pushing non-null handler on head of existing chain
	 * @param handler
	 */
	public void addHandler(IRotateHandler handler) {
		if(handler != null) {
			handler.setNextHandler(this.handler);
			this.handler = handler;
		}
	}
	
	/**
	 * the first handler that can action will handle this request 
	 * 
	 * @param request
	 */
	public Coordinate[] execute(RotateRequest request) {
		return this.handler.executeRequest(request);
	}
	
}
