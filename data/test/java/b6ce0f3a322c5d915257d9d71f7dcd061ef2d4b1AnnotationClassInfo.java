package security.annotion;

import security.api.Info;
import security.api.MethodHandler;

public class AnnotationClassInfo implements Info {
	
	private Class<?>[] relevantClasses;
	private MethodHandler handler;
	
	public AnnotationClassInfo(Class<?>[] relevantClasses, MethodHandler handler) {
		this.relevantClasses = relevantClasses;
		this.handler = handler;
	}

	@Override
	public Class<?>[] getRelevantClasses() {
		return relevantClasses;
	}

	@Override
	public MethodHandler getMethodHandler() {
		return handler;
	}

}
