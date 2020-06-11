package org.foo.httpservice.resourceapp;

import org.osgi.service.http.HttpService;
import org.osgi.service.http.NamespaceException;
import org.osgi.service.log.LogService;

public class ResourceBinder {
	private LogService s_log;

	protected void addHttpService(HttpService service) {
		try {
			service.registerResources( "/", "/html", null );
      service.registerResources( "/images", "/images", null );
		} catch (NamespaceException e) {
			s_log.log(LogService.LOG_WARNING, "Failed to register static content", e);
		}
	}
	
	protected void removeHttpService(HttpService service) {
		service.unregister("/");
		service.unregister("/images");
	}
}
