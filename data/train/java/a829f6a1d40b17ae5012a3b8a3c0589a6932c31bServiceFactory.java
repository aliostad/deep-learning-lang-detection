package ru.ildar.services.factory;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import ru.ildar.services.*;

/**
 * Factory class that provides services implementations
 */
public interface ServiceFactory
{
    public CityService getCityService();

    public FacultyService getFacultyService();

    public GradeService getGradeService();

    public GroupService getGroupService();

    public LanguageService getLanguageService();

    public UserDetailsService getUserDetailsService();

    public NewsService getNewsService();

    public PersonService getPersonService();

    public PictureService getPictureService();

    public StudentService getStudentService();

    public SubjectService getSubjectService();

    public TeacherService getTeacherService();

    public UniversityService getUniversityService();
}
