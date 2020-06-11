package cn.edu.nju.software.serviceConfig;

import cn.edu.nju.software.service.ICalendareventService;
import cn.edu.nju.software.service.IContactService;
import cn.edu.nju.software.service.IDocumentService;
import cn.edu.nju.software.service.ILoginService;
import cn.edu.nju.software.serviceImpl.CalendareventServiceImpl;
import cn.edu.nju.software.serviceImpl.ContactServiceImpl;
import cn.edu.nju.software.serviceImpl.DocumentServiceImpl;
import cn.edu.nju.software.serviceImpl.LoginServiceImpl;

public class ClientServiceHelper {
	private static IContactService contactService;
	
	private static ILoginService loginService;
	
	private static ICalendareventService calendareventService;
	
	private static IDocumentService documentService;
	
	public static IContactService getContactService() {
		if(contactService == null)
			contactService = new ContactServiceImpl();
		return contactService;
	}
	
	public static ILoginService getLoginService() {
		if(loginService == null)
			loginService = new LoginServiceImpl();
		return loginService;
	}
	
	public static ICalendareventService getCalendareventService(){
		if(calendareventService == null)
			calendareventService = new CalendareventServiceImpl();
		return calendareventService;
	}
	
	public static IDocumentService getDocumentService(){
		if( documentService == null)
			documentService = new DocumentServiceImpl();
		return documentService;
	}
	
}
