package com.litao.basic.innerclass;

interface Service {
	public void f();

	public void g();
}

interface ServiceFactory {
	public Service getService();
}

class ServiceIml1 implements Service {
	private ServiceIml1() {
	}

	@Override
	public void f() {
		System.out.println(this + " g()");
	}

	@Override
	public void g() {
		System.out.println(this + " g()");
	};

	public static ServiceFactory factory = new ServiceFactory() {

		@Override
		public Service getService() {
			return new ServiceIml1();
		}
	};
}

class ServiceIml2 implements Service {
	private ServiceIml2() {
	}

	@Override
	public void f() {
		System.out.println(this + " g()");
	}

	@Override
	public void g() {
		System.out.println(this + " g()");
	};

	/* use anonymous inner class to implement "Service Factory Pattern" */
	public static ServiceFactory factory = new ServiceFactory() {

		@Override
		public Service getService() {
			return new ServiceIml2();
		}
	};
}

public class Factorys {
	public static void serviceConsumer(ServiceFactory fact) {
		Service service = fact.getService();
		service.f();
		service.g();
	}

	public static void main(String[] args) {
		serviceConsumer(ServiceIml1.factory);
		serviceConsumer(ServiceIml1.factory);
		serviceConsumer(ServiceIml2.factory);
	}

}
