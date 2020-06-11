package net.sqs2.net;

import java.net.URLStreamHandler;
import java.net.URLStreamHandlerFactory;

public class ClassURLStreamHandlerFactory implements URLStreamHandlerFactory {

	static ClassURLStreamHandlerFactory singleton = new ClassURLStreamHandlerFactory();
	static ClassURLStreamHandler classURLStreamHandler = new ClassURLStreamHandler();
	
	private ClassURLStreamHandlerFactory(){}
	
	public static ClassURLStreamHandlerFactory getSingleton(){
		return singleton;
	}
	
	public URLStreamHandler createURLStreamHandler(String scheme) {
		if ("class".equals(scheme)){
			return classURLStreamHandler;
		} else {
			return null;
		}
	}
}
