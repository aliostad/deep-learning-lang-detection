package com.spt.evt.service.impl;

import com.spt.evt.service.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProviderService {
	private static final Logger LOGGER = LoggerFactory
			.getLogger(ProviderService.class);

	@Autowired
	private CourseService courseService;
	@Autowired
	private SubjectService subjectService;
	@Autowired
	private TopicService topicService;
	@Autowired
	private ScoreBoardService scoreBoardService;
	@Autowired
	private PersonService personService;
	@Autowired
	private RoomService roomService;
	@Autowired
	private ParticipantsService participantsService;
	@Autowired
	private AveragesCalculationService averagesCalculationService;

	public AveragesCalculationService getAveragesCalculationService() {
		return averagesCalculationService;
	}

	public void setAveragesCalculationService(AveragesCalculationService averagesCalculationService) {
		this.averagesCalculationService = averagesCalculationService;
	}

	public PersonService getPersonService() {
		return personService;
	}

	public void setPersonService(PersonService personService) {
		this.personService = personService;
	}

	public CourseService getCourseService() {
		return courseService;
	}

	public void setCourseService(CourseService courseService) {
		this.courseService = courseService;
	}

	public SubjectService getSubjectService() {
		return subjectService;
	}

	public void setSubjectService(SubjectService subjectService) {
		this.subjectService = subjectService;
	}

	public TopicService getTopicService() {
		return topicService;
	}

	public void setTopicService(TopicService topicService) {
		this.topicService = topicService;
	}

	public ScoreBoardService getScoreBoardService() {
		return scoreBoardService;
	}

	public void setScoreBoardService(ScoreBoardService scoreBoardService) {
		this.scoreBoardService = scoreBoardService;
	}

	public RoomService getRoomService() {
		return roomService;
	}

	public void setRoomService(RoomService roomService) {
		this.roomService = roomService;
	}

	public ParticipantsService getParticipantsService() {
		return participantsService;
	}

	public void setParticipantsService(ParticipantsService participantsService) {
		this.participantsService = participantsService;
	}



}