package smart.services.model;

public class ServiceNumber {

	private int id;
	private String serviceNumberId;
	private String serviceNumber;
	private String serviceId;

	// constructors
	public ServiceNumber() {

	}
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getServiceNumberId() {
		return serviceNumberId;
	}

	public void setServiceNumberId(String serviceNumberId) {
		this.serviceNumberId = serviceNumberId;
	}
	
	public String getServiceNumber() {
		return serviceNumber;
	}

	public void setServiceNumber(String serviceNumber) {
		this.serviceNumber = serviceNumber;
	}
	
	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}
}
