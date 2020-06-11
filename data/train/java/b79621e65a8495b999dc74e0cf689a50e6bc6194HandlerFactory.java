package com.sabre.tripcase.tcp.common.handler;

import org.springframework.beans.factory.annotation.Autowired;

import com.sabre.tripcase.tcp.common.preprocess.CleanText;
import com.sabre.tripcase.tcp.common.constants.Constants.ContentType;

public class HandlerFactory 
{
	private static HandlerFactory handleFactory = new HandlerFactory();
	@Autowired
	private static HtmlHandler htmlHandler;
	@Autowired
	private static TextHandler textHandler;
	@Autowired
	private static PdfHandler  pdfHandler;
	
	public static HandlerFactory createFactory(){
		return handleFactory;
	}
		
	public Handler getHandler(ContentType contenttype)
	{
		if (contenttype == ContentType.HTML)
			return htmlHandler;
		else if (contenttype == ContentType.TEXT)
			return textHandler;
		else
			return pdfHandler;
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

	/**
	 * @return the textHandler
	 */
	public TextHandler getTextHandler() {
		return textHandler;
	}

	/**
	 * @param textHandler the textHandler to set
	 */
	public void setTextHandler(TextHandler textHandler) {
		this.textHandler = textHandler;
	}
	
	/**
	 * @return the textHandler
	 */
	public PdfHandler getPdfHandler() {
		return pdfHandler;
	}

	/**
	 * @param textHandler the textHandler to set
	 */
	public void setPdfHandler(PdfHandler pdfHandler) {
		this.pdfHandler = pdfHandler;
	}
	
}
