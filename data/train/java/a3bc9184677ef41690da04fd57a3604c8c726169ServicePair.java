/**
 * 
 */
package sk.stuba.fiit.selmeci.domain_object.service;

import sk.stuba.fiit.selmeci.domain_object.service.Service;

/**
 * @author Roman Selmeci
 *
 */
public final class ServicePair {
	
	private Service service_a = null;
	
	private Service service_b = null;

	//--------------------------------------------------
	
	private ServicePair() {
	}
	
	public static ServicePair create(){
		return new ServicePair();
	}
	
	public ServicePair service_a(Service service_a){
		this.service_a = service_a;
		return this;
	}
	
	public ServicePair service_b(Service service_b){
		this.service_b = service_b;
		return this;
	}
	
	//---------------------------------------------------

	public Service getService_a() {
		return service_a;
	}

	public void setService_a(Service service_a) {
		this.service_a = service_a;
	}

	public Service getService_b() {
		return service_b;
	}

	public void setService_b(Service service_b) {
		this.service_b = service_b;
	}
	
	//-----------------------------------------------------------

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((service_a == null) ? 0 : service_a.hashCode());
		result = prime * result
				+ ((service_b == null) ? 0 : service_b.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		ServicePair other = (ServicePair) obj;
		if (service_a == null) {
			if (other.service_a != null) {
				return false;
			}
		} else if (!service_a.equals(other.service_a)) {
			return false;
		}
		if (service_b == null) {
			if (other.service_b != null) {
				return false;
			}
		} else if (!service_b.equals(other.service_b)) {
			return false;
		}
		return true;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "ServicePair [service_a=" + service_a + ", service_b="
				+ service_b + "]";
	}
	
	
}
