package jzh.design.pattern.prototype;

public class Tester {
	
	public static void main(String[] args) throws CloneNotSupportedException {
		
		ServiceA serviceA = new ServiceA("a",new ServiceB());
		ServiceA serviceA2 = (ServiceA)serviceA.clone();
		
		System.out.println(serviceA == serviceA2);
		System.out.println(serviceA.getName() == serviceA2.getName());
		System.out.println(serviceA.getName() .equals(serviceA2.getName()));
		System.out.println(serviceA.getName());
		System.out.println(serviceA2.getName());
		System.out.println(serviceA.getServiceB() == serviceA2.getServiceB());
		
	}

}
