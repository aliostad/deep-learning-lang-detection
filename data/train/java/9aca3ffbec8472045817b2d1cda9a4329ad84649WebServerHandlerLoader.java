package com.nexus.webserver;

import com.nexus.interfaces.IStaticLoader;
import com.nexus.logging.NexusLog;
import com.nexus.webserver.handlers.WebServerHandlerAction;
import com.nexus.webserver.handlers.WebServerHandlerApi;
import com.nexus.webserver.handlers.WebServerHandlerConsoleHtml;
import com.nexus.webserver.handlers.WebServerHandlerControl;
import com.nexus.webserver.handlers.WebServerHandlerHtml;
import com.nexus.webserver.handlers.WebServerHandlerMailtemplateHtml;
import com.nexus.webserver.handlers.WebServerHandlerPostPacket;

public class WebServerHandlerLoader implements IStaticLoader{
	
	@Override
	public void Load(){
		//WebServerHandlerFactory.RegisterHandler("/streamdata/", WebServerHandlerStreamdata.class);
		//WebServerHandlerFactory.RegisterHandler("/playout", WebServerHandlerIndigo.class);
		//WebServerHandlerFactory.RegisterHandler("/upload/", WebServerHandlerUpload.class);
		
		//WebServerHandlerFactory.RegisterHandler("/api/([0-9]+)/test/([0-9]+)/test2", WebServerHandlerApi.class);
		
		WebServerHandlerFactory.RegisterHandler("/api/(.*)", WebServerHandlerApi.class);
		WebServerHandlerFactory.RegisterHandler("/console/(.*)", WebServerHandlerConsoleHtml.class);
		WebServerHandlerFactory.RegisterHandler("/control/(.*)", WebServerHandlerControl.class);
		WebServerHandlerFactory.RegisterHandler("/mailtemplates/(.*)", WebServerHandlerMailtemplateHtml.class);
		WebServerHandlerFactory.RegisterHandler("/action/(.*)", WebServerHandlerAction.class);
		WebServerHandlerFactory.RegisterHandler("/postpacket/(.*)", WebServerHandlerPostPacket.class);
		WebServerHandlerFactory.RegisterHandler("/(.*)", WebServerHandlerHtml.class);
		
		NexusLog.info("Registered %d WebServer Handlers", WebServerHandlerFactory.GetHandlers().size());
	}
}
