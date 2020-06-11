package org.redsalt.core.importer.internal;

import org.redsalt.core.services.RedSaltModelService;

public class RedSaltModelServiceConsumer {

	private static RedSaltModelService service;

	public synchronized void bind(RedSaltModelService service) {
		RedSaltModelServiceConsumer.service = service;
	}

	public synchronized void unbind(RedSaltModelService service) {
		if (RedSaltModelServiceConsumer.service == service) {
			RedSaltModelServiceConsumer.service = null;
		}
	}

	public static RedSaltModelService getService() {
		return service;
	}
}
