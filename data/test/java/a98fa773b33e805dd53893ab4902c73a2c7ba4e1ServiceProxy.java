package wbs.patterns.proxy;

public class ServiceProxy implements IService {

	private IService service;

	public IService getService() {
		return service;
	}

	public void setService(IService service) {
		this.service = service;
	}

	// der proxy wird die annotations, die in der serviceImpl vor der service()- methode
	// platziert sind, auswerten und im vorliegenden fall ggf eine transaktion starten (und comitten)
	@Override
	public void service() {
		System.out.println("extra stuff from proxy");
		service.service();
	}

	public ServiceProxy(IService service) {
		this.service = service;
	}
}
