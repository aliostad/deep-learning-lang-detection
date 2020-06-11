package edu.sjtu.infosec.ismp.manager.EM.web.actions;

import org.infosec.ismp.manager.rmi.event.IEventReceive;

import edu.sjtu.infosec.ismp.manager.EM.service.IEventStatisticsService;
import edu.sjtu.infosec.ismp.manager.EM.service.IEventcorrruleService;
import edu.sjtu.infosec.ismp.manager.EM.service.IEventmoniService;
import edu.sjtu.infosec.ismp.manager.EM.service.IEventmoniinfoService;
import edu.sjtu.infosec.ismp.manager.EM.service.IEventrealdispService;
import edu.sjtu.infosec.ismp.manager.EM.service.IEventtaskseleService;
import edu.sjtu.infosec.ismp.manager.EM.service.IGetTopoInfo;
import edu.sjtu.infosec.ismp.manager.LM.pfLog.service.SystemLogService;

/**
 * 该类用来封装事件有关的Actioin中所有的service，然后把该类注入到Action中去
 * @author yang li
 *
 */
public class EventBaseClass {
	
	private IEventmoniService eventmoniService;

	private IEventtaskseleService eventtaskseleService;
	
	private IEventrealdispService eventrealdispService;
	
	private IEventStatisticsService eventStatisticsService;
	
	private IEventmoniinfoService eventmoniinfoService;

	private IEventReceive serviceClient;
	
	private IEventcorrruleService eventcorrruleService;
	
	private IGetTopoInfo getTopoInfo;
	
//	private StatisticsTime statisticsTime;
	
	private SystemLogService logService;
//
//	public StatisticsTime getStatisticsTime() {
//		return statisticsTime;
//	}
	
	public SystemLogService getLogService(){
		return this.logService;
	}
	
	public void setLogService(SystemLogService logService){
		this.logService = logService;
	}

//	public void setStatisticsTime(StatisticsTime statisticsTime) {
//		this.statisticsTime = statisticsTime;
//	}

	public IGetTopoInfo getGetTopoInfo() {
		return getTopoInfo;
	}

	public void setGetTopoInfo(IGetTopoInfo getTopoInfo) {
		this.getTopoInfo = getTopoInfo;
	}

	public IEventmoniService getEventmoniService() {
		return eventmoniService;
	}

	public void setEventmoniService(IEventmoniService eventmoniService) {
		this.eventmoniService = eventmoniService;
	}

	public IEventtaskseleService getEventtaskseleService() {
		return eventtaskseleService;
	}

	public void setEventtaskseleService(IEventtaskseleService eventtaskseleService) {
		this.eventtaskseleService = eventtaskseleService;
	}

	public IEventrealdispService getEventrealdispService() {
		return eventrealdispService;
	}

	public void setEventrealdispService(IEventrealdispService eventrealdispService) {
		this.eventrealdispService = eventrealdispService;
	}

	public IEventStatisticsService getEventStatisticsService() {
		return eventStatisticsService;
	}

	public void setEventStatisticsService(
			IEventStatisticsService eventStatisticsService) {
		this.eventStatisticsService = eventStatisticsService;
	}

	public IEventReceive getServiceClient() {
		return serviceClient;
	}

	public void setServiceClient(IEventReceive serviceClient) {
		this.serviceClient = serviceClient;
	}

	public IEventcorrruleService getEventcorrruleService() {
		return eventcorrruleService;
	}

	public void setEventcorrruleService(IEventcorrruleService eventcorrruleService) {
		this.eventcorrruleService = eventcorrruleService;
	}
	
	public IEventmoniinfoService getEventmoniinfoService() {
		return eventmoniinfoService;
	}

	public void setEventmoniinfoService(IEventmoniinfoService eventmoniinfoService) {
		this.eventmoniinfoService = eventmoniinfoService;
	}
}
