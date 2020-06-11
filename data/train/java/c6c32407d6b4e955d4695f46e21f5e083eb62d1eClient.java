package edu.ustc.sse.cdp.behavior.chainOfResponsibility;

public class Client {
	
	public String handleByConcreteHandlerA(String condition) {
		
		Handler handler = new ConcreteHandlerA();
		
		return handler.handle(condition);
	}
	
	public String handleByConcreteHandlerAB(String condition) {
		
		Handler a = new ConcreteHandlerA();
		Handler b = new ConcreteHandlerB();
		
		a.setSuccessor(b);
		
		return a.handle(condition);
	}
	
	public String handleByConcreteHandlerABC(String condition) {
		
		Handler a = new ConcreteHandlerA();
		Handler b = new ConcreteHandlerB();
		Handler c = new ConcreteHandlerC();
		
		a.setSuccessor(b);
		b.setSuccessor(c);
		
		return a.handle(condition);
	}
}
