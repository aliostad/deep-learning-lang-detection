package io.redspark.ireadme.service;

import io.redspark.ireadme.repository.ActionRepository;
import io.redspark.ireadme.repository.StepRepository;
import io.redspark.ireadme.repository.TeamRepository;
import io.redspark.ireadme.repository.ToolRepository;
import io.redspark.ireadme.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class IReadmeRepository {

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private TeamRepository teamRepository;
	
	@Autowired
	private ToolRepository toolRepository;
	
	@Autowired
	private ActionRepository actionRepository;
	
	@Autowired
	private StepRepository stepRepository;

	public UserRepository getUserRepository() {
		return userRepository;
	}
	
	public TeamRepository getTeamRepository() {
		return teamRepository;
	}
	
	public ToolRepository getToolRepository() {
		return toolRepository;
	}
	
	public ActionRepository getActionRepository() {
		return actionRepository;
	}

	public StepRepository getStepRepository() {
		return stepRepository;
	}
}
