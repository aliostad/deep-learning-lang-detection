package com.wally.pattern.facade;

public class Facade {
	
	ServiceA serviceA;
	ServiceB serviceB;
	ServiceC serviceC;
	
	public Facade() {
		
		serviceA = new ServiceAImpl();
		serviceB = new ServiceBImpl();
		serviceC = new ServiceCImpl();
	}
	
	public void methodA() {
		serviceA.methodA();
		serviceB.methodB();
    }
    
    public void methodB() {
    	serviceB.methodB();
    	serviceC.methodC();
    }
    
    public void methodC() {
    	serviceC.methodC();
    	serviceA.methodA();
    }


}
