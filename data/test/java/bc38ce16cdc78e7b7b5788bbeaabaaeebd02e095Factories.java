package testJava.Interface;

interface Service{
	void f1();
	void f2();
}

interface ServiceFactory{
	Service getService();
}

class ServiceImA implements Service{
	ServiceImA(){};
	@Override
	public void f1() {	}
	@Override
	public void f2() {	}
	
}

class ServiceImB implements Service{
	ServiceImB(){};
	@Override
	public void f1() {	}
	@Override
	public void f2() {	}
}

class ServiceFactoryA implements ServiceFactory{
	@Override
	public Service getService() {
		return new ServiceImA();
	}
}

class ServiceFactoryB implements ServiceFactory{
	@Override
	public Service getService() {
		return new ServiceImB();
	}
}

public class Factories {
	public static void serviceConsumer(ServiceFactory fact){
		Service s=fact.getService();
		s.f1();
		s.f2();
	}
	
	public static void main(String[] args){
		serviceConsumer(new ServiceFactoryA());
		serviceConsumer(new ServiceFactoryA());
	}
}
