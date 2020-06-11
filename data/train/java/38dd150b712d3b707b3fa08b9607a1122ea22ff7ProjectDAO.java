package com.epidata.talks.dependencyinjection.base.simple;

import com.epidata.talks.dependencyinjection.model.Project;
import com.epidata.talks.dependencyinjection.model.repository.JSONProjectRepository;
import com.epidata.talks.dependencyinjection.model.repository.ProjectRepository;

public class ProjectDAO {

	private ProjectRepository projectRepository;
	
	public ProjectDAO() {
		projectRepository = new JSONProjectRepository();
	}

	public Project findByName(String name) {
		return projectRepository.findByName(name);
	}
}
