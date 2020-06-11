package com.jike.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AllService {
	@Autowired
	private UserService userService;

	public UserService getUserService() {
		return userService;
	}
	@Autowired
	private CurriculumService curriculumService;

	/**
	 * @return the curriculumService
	 */
	public CurriculumService getCurriculumService() {
		return curriculumService;
	}
	@Autowired
	private DurationService durationService;

	/**
	 * @return the durationService
	 */
	public DurationService getDurationService() {
		return durationService;
	}
	
}
