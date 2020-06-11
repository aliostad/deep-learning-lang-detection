package com.baron.di.case3;



public class DIExampleController {

	private DIExampleService service;
	
	// DI기술 없이 서비스 객체가 필요할때
	// 내부에 만들거나
	//private DIExampleService service = new DIExampleService();
	
	// 생성자에서 만들거나..
	/*public DIExampleController() {
		this.service = new DIExampleService();
	}*/
	
	// DI가 있다면..?
	// 어딘가에서 서비스를 주겠지
	/*public DIExampleController(DIExampleService service) {
		this.service = service;
	}*/
	
	// setter를 통해서 받을수도 있다
	public void setService(DIExampleService service) {
		this.service = service;
	}
	
	public DIExampleService getService() {
		return service;
	}
}