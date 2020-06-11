package andex.service;

import android.os.Binder;
import android.os.Handler;

/**
 * Base class for any service binder.
 * @author 
 *
 */
public class BaseServiceBinder<T extends BaseService> extends Binder {
	
	protected T service;
	
	public Handler handler;
	
	public BaseServiceBinder() {
		this.handler = new Handler();
	}
	
	public BaseServiceBinder(T service) {
		this();
		this.service = service;
	}
	
	public boolean isServiceRunning() {
		return service.isServiceRunning;
	}

	public void stopService() {
		if (service.isServiceRunning) {
			service.stopService();
		}
	}
	
	public void restartService() {
		if (service.isServiceRunning) {
			service.restartService();
		}
	}
}
