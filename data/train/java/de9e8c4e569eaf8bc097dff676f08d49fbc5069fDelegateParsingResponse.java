package dk.defiant.xml.digester.responses;

import dk.defiant.xml.digester.DigesterEventHandler;
import dk.defiant.xml.digester.HandlerResponse;

public class DelegateParsingResponse extends HandlerResponse {

	public DelegateParsingResponse(Class<? extends DigesterEventHandler> handlerClass) {
		super(HandlerResponse.Type.DELEGATE, null, null, handlerClass);
	}

	public DelegateParsingResponse(Class<? extends DigesterEventHandler> handlerClass, Object digestTarget) {
		super(HandlerResponse.Type.DELEGATE, null, digestTarget, handlerClass);
	}

	public DelegateParsingResponse(DigesterEventHandler handler) {
		super(HandlerResponse.Type.DELEGATE, handler, null, null);
	}
	
	public DelegateParsingResponse(DigesterEventHandler handler, Object digestTarget) {
		super(HandlerResponse.Type.DELEGATE, handler, digestTarget, null);
	}
}
