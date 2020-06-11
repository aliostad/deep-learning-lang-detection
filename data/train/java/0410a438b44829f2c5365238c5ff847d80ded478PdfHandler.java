package com.sabre.tripcase.tcp.common.handler;

import org.springframework.beans.factory.annotation.Autowired;

public class PdfHandler implements Handler 
{
	@Autowired
	private HtmlHandler htmlHandler; 
	@Override
	public String convertToText(String content) {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * @return the htmlHandler
	 */
	public HtmlHandler getHtmlHandler() {
		return htmlHandler;
	}

	/**
	 * @param htmlHandler the htmlHandler to set
	 */
	public void setHtmlHandler(HtmlHandler htmlHandler) {
		this.htmlHandler = htmlHandler;
	}
	

}
