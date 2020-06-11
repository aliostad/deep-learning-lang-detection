package com.ip.notifier;

import java.util.HashMap;
import java.util.Map;

import org.boris.winrun4j.Service;

public enum ServiceControlEnum{ 
	
	SERVICE_CONTROL_STOP(Service.SERVICE_CONTROL_STOP, "SERVICE_CONTROL_STOP"), 
	SERVICE_CONTROL_PAUSE(Service.SERVICE_CONTROL_PAUSE, "SERVICE_CONTROL_PAUSE"),
	SERVICE_CONTROL_CONTINUE(Service.SERVICE_CONTROL_STOP, "SERVICE_CONTROL_STOP"),
	SERVICE_CONTROL_INTERROGATE(Service.SERVICE_CONTROL_INTERROGATE, "SERVICE_CONTROL_INTERROGATE"),
	SERVICE_CONTROL_SHUTDOWN(Service.SERVICE_CONTROL_SHUTDOWN, "SERVICE_CONTROL_SHUTDOWN"),
	SERVICE_CONTROL_PARAMCHANGE(Service.SERVICE_CONTROL_PARAMCHANGE, "SERVICE_CONTROL_PARAMCHANGE"),
	SERVICE_CONTROL_NETBINDADD(Service.SERVICE_CONTROL_NETBINDADD, "SERVICE_CONTROL_NETBINDADD"),
	SERVICE_CONTROL_NETBINDREMOVE(Service.SERVICE_CONTROL_NETBINDREMOVE, "SERVICE_CONTROL_NETBINDREMOVE"),
	SERVICE_CONTROL_NETBINDENABLE(Service.SERVICE_CONTROL_NETBINDENABLE, "SERVICE_CONTROL_NETBINDENABLE"),
	SERVICE_CONTROL_NETBINDDISABLE(Service.SERVICE_CONTROL_NETBINDDISABLE, "SERVICE_CONTROL_NETBINDDISABLE"),
	SERVICE_CONTROL_DEVICEEVENT(Service.SERVICE_CONTROL_DEVICEEVENT, "SERVICE_CONTROL_DEVICEEVENT"),
	SERVICE_CONTROL_HARDWAREPROFILECHANGE(Service.SERVICE_CONTROL_HARDWAREPROFILECHANGE, "SERVICE_CONTROL_HARDWAREPROFILECHANGE"),
	SERVICE_CONTROL_POWEREVENT(Service.SERVICE_CONTROL_POWEREVENT, "SERVICE_CONTROL_POWEREVENT"),
	SERVICE_CONTROL_SESSIONCHANGE(Service.SERVICE_CONTROL_SESSIONCHANGE, "SERVICE_CONTROL_SESSIONCHANGE");
	
	static private Map<Integer, ServiceControlEnum> controlMap = 
			new HashMap<Integer, ServiceControlEnum>();
	
	static{
		for(ServiceControlEnum control : ServiceControlEnum.values()){
			controlMap.put(control.getId(), control);
		}
	}
	
	private int id;
	private String description;
	
	ServiceControlEnum(int id, String description){
		this.id = id; 
		this.description = description;
	}

	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}
	
	/**
	 * @return the description
	 */
	public static String getDescription(int id) {
		return controlMap.get(id).getDescription();
	}
};
