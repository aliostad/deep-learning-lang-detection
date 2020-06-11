package ru.ildar.services.factory.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;
import ru.ildar.services.*;
import ru.ildar.services.factory.ServiceFactory;

@Component
public class JpaServiceFactory implements ServiceFactory
{
    @Autowired
    @Qualifier("cityServiceJpaImpl")
    private CityService cityService;

    @Autowired
    @Qualifier("facultyServiceJpaImpl")
    private FacultyService facultyService;

    @Autowired
    @Qualifier("gradeServiceJpaImpl")
    private GradeService gradeService;

    @Autowired
    @Qualifier("groupServiceJpaImpl")
    private GroupService groupService;

    @Autowired
    @Qualifier("languageServiceJpaImpl")
    private LanguageService languageService;

    @Autowired
    @Qualifier("loginUserDetailsService")
    private UserDetailsService userDetailsService;

    @Autowired
    @Qualifier("newsServiceJpaImpl")
    private NewsService newsService;

    @Autowired
    @Qualifier("personServiceJpaImpl")
    private PersonService personService;

    @Autowired
    @Qualifier("pictureServiceJpaImpl")
    private PictureService pictureService;

    @Autowired
    @Qualifier("studentServiceJpaImpl")
    private StudentService studentService;

    @Autowired
    @Qualifier("subjectServiceJpaImpl")
    private SubjectService subjectService;

    @Autowired
    @Qualifier("teacherServiceJpaImpl")
    private TeacherService teacherService;

    @Autowired
    @Qualifier("universityServiceJpaImpl")
    private UniversityService universityService;

    public CityService getCityService()
    {
        return cityService;
    }

    public FacultyService getFacultyService()
    {
        return facultyService;
    }

    public GradeService getGradeService()
    {
        return gradeService;
    }

    public GroupService getGroupService()
    {
        return groupService;
    }

    public LanguageService getLanguageService()
    {
        return languageService;
    }

    public UserDetailsService getUserDetailsService()
    {
        return userDetailsService;
    }

    public NewsService getNewsService()
    {
        return newsService;
    }

    public PersonService getPersonService()
    {
        return personService;
    }

    public PictureService getPictureService()
    {
        return pictureService;
    }

    public StudentService getStudentService()
    {
        return studentService;
    }

    public SubjectService getSubjectService()
    {
        return subjectService;
    }

    public TeacherService getTeacherService()
    {
        return teacherService;
    }

    public UniversityService getUniversityService()
    {
        return universityService;
    }
}
