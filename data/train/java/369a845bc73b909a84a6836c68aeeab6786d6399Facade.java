package struct.facade.facade;

import struct.facade.service.ServiceA;
import struct.facade.service.ServiceAImpl;
import struct.facade.service.ServiceB;
import struct.facade.service.ServiceBImpl;
import struct.facade.service.ServiceC;
import struct.facade.service.ServiceCImpl;

public class Facade {

	ServiceA sa;
	ServiceB sb;
	ServiceC sc;
	
	public Facade(){
		sa = new ServiceAImpl();
		sb = new ServiceBImpl();
		sc = new ServiceCImpl();
	}
	
	public void methodA(){
		sa.methodA();
		sb.methodB();
	}
	
	public void methodB(){
		sb.methodB();
		sc.methodC();
	}
	
	public void methodC(){
		sc.methodC();
		sa.methodA();
	}
	
}
