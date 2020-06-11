package behavioral_patterns.chainOfResponsibility.src;

import behavioral_patterns.chainOfResponsibility.src.handler.EasyRequestHandler;
import behavioral_patterns.chainOfResponsibility.src.handler.HardRequestHandler;
import behavioral_patterns.chainOfResponsibility.src.handler.MiddleRequestHandler;

public class HandlerMaster {

	RequestHandler handler;

	public HandlerMaster() {
		init();
	}

	private void init() {
		this.handler = new EasyRequestHandler(new MiddleRequestHandler(
				new HardRequestHandler(null)));
	}

	public Response handle(Request request) {
		return this.handler.handl(request);
	}

}
