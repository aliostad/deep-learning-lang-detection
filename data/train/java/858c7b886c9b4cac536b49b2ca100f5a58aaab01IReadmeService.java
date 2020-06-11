package io.redspark.ireadme.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class IReadmeService {

	@Autowired
	private UserService userService;

	@Autowired
	private TeamService teamService;
	
	@Autowired
	private ToolService toolService;
	
	@Autowired
	private ActionService actionService;
	
	@Autowired
	private StepService stepService;
	
	public TeamService getTeamService() {
		return teamService;
	}
	
	public UserService getUserService() {
		return userService;
	}
	
	public ToolService getToolService() {
		return toolService;
	}
	
	public ActionService getActionService() {
		return actionService;
	}
	
	public StepService getStepService() {
		return stepService;
	}
}
