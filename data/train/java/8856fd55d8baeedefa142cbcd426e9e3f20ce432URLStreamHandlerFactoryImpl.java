package jboot.repository.client.protocol;

import java.net.URLStreamHandler;
import java.net.URLStreamHandlerFactory;

import jboot.repository.client.IRepository;
import jboot.repository.client.protocol.repo.Handler;

public class URLStreamHandlerFactoryImpl implements URLStreamHandlerFactory {

	private IRepository repository;
	private Handler handler;

	public URLStreamHandlerFactoryImpl(IRepository repository) {
		this.repository = repository;
	}

	@Override
	public URLStreamHandler createURLStreamHandler(String protocol) {
		if ("repo".equals(protocol)) {
			if (handler == null) {
				handler = new Handler(repository);
			}
			return handler;
		}
		return null;
	}

}
