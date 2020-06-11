package org.xtremeware.iudex.businesslogic.service;

import org.xtremeware.iudex.dao.AbstractDaoFactory;
import org.xtremeware.iudex.helper.ExternalServiceConnectionException;
import org.xtremeware.iudex.vo.MailingConfigVo;

/**
 * ServiceFactory
 *
 * @author juan
 */
public class ServiceFactory {

	private UsersService usersService;
	private ProfessorsService professorsService;
	private SubjectsService subjectsService;
	private FeedbacksService feedbacksService;
	private CommentsService commentsService;
	private CoursesService coursesService;
	private SubjectRatingsService subjectRatingsService;
	private ProfessorRatingsService professorRatingsService;
	private CommentRatingsService commentRatingService;
	private CourseRatingsService courseRatingsService;
	private MailingService mailingService;
	private PeriodsService periodsService;
	private ProgramsService programsService;
	private FeedbackTypesService feedbackTypesService;
	private LogService logService;

	public ServiceFactory(AbstractDaoFactory daoFactory, MailingConfigVo mailingConfig) throws ExternalServiceConnectionException {
		usersService = new UsersService(daoFactory);
		professorsService = new ProfessorsService(daoFactory);
		subjectsService = new SubjectsService(daoFactory);
		feedbacksService = new FeedbacksService(daoFactory);
		commentsService = new CommentsService(daoFactory);
		coursesService = new CoursesService(daoFactory);
		subjectRatingsService = new SubjectRatingsService(daoFactory);
		professorRatingsService = new ProfessorRatingsService(daoFactory);
		commentRatingService = new CommentRatingsService(daoFactory);
		courseRatingsService = new CourseRatingsService(daoFactory);
		mailingService = new MailingService(mailingConfig);
		periodsService = new PeriodsService(daoFactory);
		programsService = new ProgramsService(daoFactory);
		feedbackTypesService = new FeedbackTypesService(daoFactory);
		logService = new LogService();
	}

	public CommentRatingsService createCommentRatingService() {
		return commentRatingService;
	}

	public CommentsService createCommentsService() {
		return commentsService;
	}

	public CourseRatingsService createCourseRatingsService() {
		return courseRatingsService;
	}

	public CoursesService createCoursesService() {
		return coursesService;
	}

	public FeedbackTypesService createFeedbackTypesService() {
		return feedbackTypesService;
	}

	public FeedbacksService createFeedbacksService() {
		return feedbacksService;
	}

	public MailingService createMailingService() {
		return mailingService;
	}

	public PeriodsService createPeriodsService() {
		return periodsService;
	}

	public ProfessorRatingsService createProfessorRatingsService() {
		return professorRatingsService;
	}

	public ProfessorsService createProfessorsService() {
		return professorsService;
	}

	public ProgramsService createProgramsService() {
		return programsService;
	}

	public SubjectRatingsService createSubjectRatingsService() {
		return subjectRatingsService;
	}

	public SubjectsService createSubjectsService() {
		return subjectsService;
	}

	public UsersService createUsersService() {
		return usersService;
	}

	public LogService createLogService() {
		return logService;
	}
}
