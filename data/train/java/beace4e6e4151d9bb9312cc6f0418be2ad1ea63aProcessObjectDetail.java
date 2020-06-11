package com.viewfunction.vfbpm.adminCenter.UI.processManagement;

import java.util.List;

import com.vaadin.ui.Embedded;
import com.vaadin.ui.Panel;
import com.vaadin.ui.VerticalLayout;
import com.vaadin.ui.themes.Reindeer;
import com.viewfunction.processRepository.exception.ProcessRepositoryRuntimeException;
import com.viewfunction.processRepository.processBureau.ProcessObject;
import com.viewfunction.processRepository.processBureau.ProcessSpace;
import com.viewfunction.processRepository.util.factory.ProcessComponentFactory;
import com.viewfunction.vfbpm.adminCenter.UI.UICommonElementDefination;
import com.viewfunction.vfbpm.adminCenter.UI.element.MainTitleBar;
import com.viewfunction.vfbpm.adminCenter.UI.element.SectionTitleBar;
import com.viewfunction.vfbpm.adminCenter.UI.processManagement.ProcessObjectQueryEvent.ProcessObjectQueryListener;
import com.viewfunction.vfbpm.adminCenter.util.UserClientInfo;

public class ProcessObjectDetail extends VerticalLayout implements ProcessObjectQueryListener{
	private static final long serialVersionUID = -6839145423602902026L;
	
	private UserClientInfo userClientInfo;
	private ProcessManagementPanel processManagementPanel;
	public VerticalLayout processObjectContainer;
	
	public ProcessObjectDetail(UserClientInfo userClientInfo){
		this.userClientInfo=userClientInfo;
		userClientInfo.getEventBlackboard().addListener(this);
		processObjectContainer=new VerticalLayout();
		//render title bar		
		MainTitleBar mainTitleBar=new MainTitleBar(this.userClientInfo.getI18NProperties().getProperty("ProcessManage_ProcessObjectDetail_processspaceNameLabel"),
				this.userClientInfo.getI18NProperties().getProperty("ProcessManage_ProcessObjectDetail_currentProcessTypeLabel"));	
		processObjectContainer.addComponent(mainTitleBar);		
		this.addComponent(processObjectContainer);
	}
	
	public ProcessManagementPanel getProcessManagementPanel() {
		return processManagementPanel;
	}

	public void setProcessManagementPanel(ProcessManagementPanel processManagementPanel) {
		this.processManagementPanel = processManagementPanel;
	}

	public void receiveProcessObjectQuery(ProcessObjectQueryEvent event) {		
		processObjectContainer.removeAllComponents();		
		MainTitleBar mainTitleBar=new MainTitleBar(event.getProcessSpaceName(),event.getProcessType());	
		processObjectContainer.addComponent(mainTitleBar);	
		
		Panel containerPanel=new Panel();
		containerPanel.setStyleName(Reindeer.PANEL_LIGHT);
		containerPanel.setScrollable(true);
		containerPanel.setSizeFull();		
		processObjectContainer.addComponent(containerPanel);			
		
		int processStatus=event.getProcessStatus();		
		SectionTitleBar sectionTitleBar=null;		
		if(processStatus==ProcessSpace.PROCESS_STATUS_UNFINISHED){
			sectionTitleBar=new SectionTitleBar(new Embedded(null, UICommonElementDefination.ICON_processManagement_runningProcessIcon_big),
					this.userClientInfo.getI18NProperties().getProperty("ProcessManage_ProcessObjectDetail_processType_runningLabel"),SectionTitleBar.MIDDLEFONT,null);			
		}
		if(processStatus==ProcessSpace.PROCESS_STATUS_FINISHED){
			sectionTitleBar=new SectionTitleBar(new Embedded(null, UICommonElementDefination.ICON_processManagement_finishedProcessIcon_big),
					this.userClientInfo.getI18NProperties().getProperty("ProcessManage_ProcessObjectDetail_processType_finishedLabel"),SectionTitleBar.MIDDLEFONT,null);	
		}
		if(processStatus==ProcessSpace.PROCESS_STATUS_ALL){
			sectionTitleBar=new SectionTitleBar(new Embedded(null, UICommonElementDefination.ICON_processManagement_allProcessIcon_big),
					this.userClientInfo.getI18NProperties().getProperty("ProcessManage_ProcessObjectDetail_processType_allLabel"),SectionTitleBar.MIDDLEFONT,null);	
		}		
		containerPanel.addComponent(sectionTitleBar);	
		
		VerticalLayout processObjectTableContainer=new VerticalLayout();
		containerPanel.addComponent(processObjectTableContainer);
		
		try {
			ProcessSpace targetProcessSpace=ProcessComponentFactory.connectProcessSpace(event.getProcessSpaceName());			
			List<ProcessObject> processObjectList=targetProcessSpace.getProcessObjectsByProcessType(event.getProcessType(), processStatus);
			
			ProcessObjectsTable ProcessObjectsTable=new ProcessObjectsTable(this.userClientInfo,processObjectList,processStatus);
			processObjectTableContainer.addComponent(ProcessObjectsTable);
			
		} catch (ProcessRepositoryRuntimeException e) {			
			e.printStackTrace();
		}
	}
}