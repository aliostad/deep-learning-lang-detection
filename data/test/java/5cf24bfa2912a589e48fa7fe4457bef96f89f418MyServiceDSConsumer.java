package myinjection;

import myinjection.service.MyServiceDS;

public class MyServiceDSConsumer{
	
	private static MyServiceDS service;

	public synchronized void setSrv(MyServiceDS service) {
		System.out.println("Service MyServiceDS was set!");
		this.service = service;
	}

	// Method will be used by DS to unset the quote service
	public synchronized void unsetSrv(MyServiceDS service) {
		System.out.println("Service MyServiceDS was unset.");
		if (this.service == service) {
			this.service = null;
		}
	}
	
	
	public static String[] getList(){
		if(service == null){
			System.out.println("Service MyServiceDS is null!!!");
			return new String[]{"OneDS","twoDS"};
		}
		return service.getList();
	}

}
