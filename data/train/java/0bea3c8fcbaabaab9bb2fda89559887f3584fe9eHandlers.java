package it.dangelo.saj.impl.parser;

import it.dangelo.saj.parser.ContentHandler;
import it.dangelo.saj.parser.ErrorHandler;
import it.dangelo.saj.parser.ResourceResolver;

public class Handlers {
	private ContentHandler contentHandler;
	private ErrorHandler errorHandler;
	private ResourceResolver resourceResolver;
	public Handlers(ContentHandler contentHandler, 
					ErrorHandler errorHandler,
					ResourceResolver resolver) {
		super();
		this.contentHandler = contentHandler;
		this.errorHandler = errorHandler;
		this.resourceResolver = resolver;
	}
	public ContentHandler getContentHandler() {
		return contentHandler;
	}
	public void setContentHandler(ContentHandler contentHandler) {
		this.contentHandler = contentHandler;
	}
	public ErrorHandler getErrorHandler() {
		return errorHandler;
	}
	public void setErrorHandler(ErrorHandler errorHandler) {
		this.errorHandler = errorHandler;
	}
	
	public void setResourceResolver(ResourceResolver resourceResolver) {
		this.resourceResolver = resourceResolver;
	}
	
	public ResourceResolver getResourceResolver() {
		return resourceResolver;
	}
	
	
}
