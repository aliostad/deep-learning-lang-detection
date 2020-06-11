package com.sun.app.service;

import com.sun.app.service.front.FrontNewsService;
import com.sun.app.service.front.ProjectService;


/**
 * @author LH
 *
 */
public class FrontServiceManager { 
	
	private ProjectService projectService;
	private FrontNewsService frontnewsService;

	
	public FrontNewsService getFrontnewsService() {
		return frontnewsService;
	}

	public void setFrontnewsService(FrontNewsService frontnewsService) {
		this.frontnewsService = frontnewsService;
	}

	public ProjectService getProjectService() {
		return projectService;
	}

	public void setProjectService(ProjectService projectService) {
		this.projectService = projectService;
	}
	
	
	
}
