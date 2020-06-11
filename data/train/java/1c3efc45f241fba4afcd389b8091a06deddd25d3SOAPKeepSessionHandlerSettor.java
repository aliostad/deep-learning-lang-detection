package cm.h3c.college.pay.core.ws.soap;

import java.util.List;

import javax.xml.ws.Binding;
import javax.xml.ws.BindingProvider;
import javax.xml.ws.handler.Handler;

import org.apache.log4j.Logger;

public class SOAPKeepSessionHandlerSettor {
	
	private static Logger log = Logger.getLogger(SOAPKeepSessionHandlerSettor.class);
	
	private ThreadLocal<SOAPKeepSessionHandler> keepSessionHandler = new ThreadLocal<SOAPKeepSessionHandler>();
	
	private static SOAPKeepSessionHandlerSettor instance;
	
	private SOAPKeepSessionHandlerSettor() {}
	
	public static SOAPKeepSessionHandlerSettor getInstance() {
		
		if (instance == null) {
			instance = new SOAPKeepSessionHandlerSettor();
		}
		
		return instance;
	}
	
	
	public void addHandler(BindingProvider proxy) {
		
		if (proxy == null) {
			return;
		}

		SOAPKeepSessionHandler handler = keepSessionHandler.get();
		
		if (handler == null) {
			handler = new SOAPKeepSessionHandler();
			keepSessionHandler.set(handler);
		}

		Binding binding = ((BindingProvider) proxy).getBinding();

		List<Handler> handlerList = binding.getHandlerChain();// 获得Handler链

		if (!handlerList.contains(handler)) {// 防止重复插入Handler
			handlerList.add(handler);
			binding.setHandlerChain(handlerList);
		}

	}
	
	public void removeHandler(BindingProvider proxy) {
		
		SOAPKeepSessionHandler handler = keepSessionHandler.get();
		
		if (handler == null) {
			log.warn("it can't get keepSessionHandler.");
			return;
		}
		
		Binding binding = ((BindingProvider) proxy).getBinding();
		
		List<Handler> handlerList = binding.getHandlerChain();// 获得Handler链
		
		if (handlerList.contains(handler)) {// 防止重复插入Handler
			handlerList.remove(handler);
			binding.setHandlerChain(handlerList);
		} else {
			log.warn("it can't remove keepSessionHandler, baseuse it can not be found.");
		}
		
	}
}
