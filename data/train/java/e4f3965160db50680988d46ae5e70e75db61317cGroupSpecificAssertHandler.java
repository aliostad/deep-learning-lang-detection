package cz.cuni.mff.d3s.jdeeco.cloudsimulator.asserts;

import java.util.concurrent.ConcurrentHashMap;

public class GroupSpecificAssertHandler implements AssertHandler {

	private final ConcurrentHashMap<String, AssertHandler> specificHandlers = new ConcurrentHashMap<>();
	private AssertHandler defaultHandler;

	public GroupSpecificAssertHandler(AssertHandler defaultHandler) {
		this.defaultHandler = defaultHandler;
	}

	public void setDefaultHandler(AssertHandler handler) {
		this.defaultHandler = handler;
	}

	public void setSpecificHandler(String group, AssertHandler handler) {
		specificHandlers.put(group, handler);
	}

	public void clearSpecificHandler(String group) {
		specificHandlers.remove(group);
	}

	private AssertHandler getHandler(String group) {
		if (specificHandlers.containsKey(group)) {
			return specificHandlers.get(group);
		}
		return defaultHandler;
	}

	@Override
	public void fail(String message, String assertionGroup) {
		getHandler(assertionGroup).fail(message, assertionGroup);
	}

	@Override
	public void success(String message, String assertionGroup) {
		getHandler(assertionGroup).success(message, assertionGroup);
	}
}
