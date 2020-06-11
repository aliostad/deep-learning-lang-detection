package com.todo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.todo.domain.Acf2Id;
import com.todo.domain.Priority;
import com.todo.domain.Project;
import com.todo.domain.TaskStatus;
import com.todo.repository.Acf2IdRepository;
import com.todo.repository.PriorityRepository;
import com.todo.repository.ProjectRepository;
import com.todo.repository.TaskStatusRepository;

/**
 * @author vinodkumara
 *
 */
@Service
public class RefDataService {

	/**
	 * priorityRepository.
	 */
	@Autowired
	private PriorityRepository priorityRepository;

	/**
	 * taskStatusRepository.
	 */
	@Autowired
	private TaskStatusRepository taskStatusRepository;

	/**
	 * projectRepository.
	 */
	@Autowired
	private ProjectRepository projectRepository;
	
	/**
	 * acf2IdRepository.
	 */
	@Autowired
	private Acf2IdRepository acf2IdRepository;

	/**
	 * @return List<Priority>
	 */
	public List<Priority> readPriority() {
		return priorityRepository.findAll();
	}

	/**
	 * @return List<TaskStatus>
	 */
	public List<TaskStatus> readTaskStatus() {
		return taskStatusRepository.findAll();
	}

	/**
	 * @return List<Project>
	 */
	public List<Project> readProject() {
		return projectRepository.findAll();
	}
	
	public List<Acf2Id> readAcf2Id() {
		return acf2IdRepository.findAll();
	}

}
