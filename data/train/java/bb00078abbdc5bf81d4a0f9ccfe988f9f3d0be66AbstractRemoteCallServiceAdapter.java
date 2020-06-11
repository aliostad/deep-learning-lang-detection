package mtcls.client.event.remote;

public class AbstractRemoteCallServiceAdapter<T> extends AbstractRemoteCallAdapter<T>
	implements HasRemoteCallAndService<T>{
	protected String serviceName;
	public AbstractRemoteCallServiceAdapter(){
		this(null);
	}
	public AbstractRemoteCallServiceAdapter(String serviceName){
		setServiceName(serviceName);
	}
	/**
	 * @return the serviceName
	 */
	public String getServiceName() {
		return serviceName;
	}

	/**
	 * @param serviceName the serviceName to set
	 */
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

}
