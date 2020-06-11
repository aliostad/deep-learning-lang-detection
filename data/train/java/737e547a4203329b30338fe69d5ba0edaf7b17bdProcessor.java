package be.kuleuven.cs.oss.control;

import org.sonar.api.charts.ChartParameters;

public class Processor<M> {
	private IHandler<M> firstHandler;
	private IHandler<M> prevHandler;
	
	public void addHandler(IHandler<M> handler) {
		if(firstHandler == null) {
			firstHandler = handler;
		}
		
		if(prevHandler != null)
		{
			prevHandler.setNext(handler);
		}
		prevHandler = handler;
	}
	
	public void startProcess(M mutableObject, ChartParameters params) {
		firstHandler.handleRequest(mutableObject, params);
	}
}
