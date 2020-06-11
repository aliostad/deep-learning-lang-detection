package ru.ildar.controllers.test;

import org.springframework.security.core.userdetails.UserDetailsService;
import ru.ildar.database.entities.Language;
import ru.ildar.services.*;
import ru.ildar.services.factory.ServiceFactory;

import static org.mockito.Mockito.mock;

public class MockServiceFactory implements ServiceFactory
{
    private CityService cityService = mock(CityService.class);
    private FacultyService facultyService = mock(FacultyService.class);
    private GradeService gradeService = mock(GradeService.class);
    private GroupService groupService = mock(GroupService.class);
    private LanguageService languageService = mock(LanguageService.class);
    private UserDetailsService userDetailsService = mock(UserDetailsService.class);
    private NewsService newsService = mock(NewsService.class);
    private PersonService personService = mock(PersonService.class);
    private PictureService pictureService = mock(PictureService.class);
    private StudentService studentService = mock(StudentService.class);
    private SubjectService subjectService = mock(SubjectService.class);
    private TeacherService teacherService = mock(TeacherService.class);
    private UniversityService universityService = mock(UniversityService.class);

    @Override
    public CityService getCityService()
    {
        return cityService;
    }

    @Override
    public FacultyService getFacultyService()
    {
        return facultyService;
    }

    @Override
    public GradeService getGradeService()
    {
        return gradeService;
    }

    @Override
    public GroupService getGroupService()
    {
        return groupService;
    }

    @Override
    public LanguageService getLanguageService()
    {
        return languageService;
    }

    @Override
    public UserDetailsService getUserDetailsService()
    {
        return userDetailsService;
    }

    @Override
    public NewsService getNewsService()
    {
        return newsService;
    }

    @Override
    public PersonService getPersonService()
    {
        return personService;
    }

    @Override
    public PictureService getPictureService()
    {
        return pictureService;
    }

    @Override
    public StudentService getStudentService()
    {
        return studentService;
    }

    @Override
    public SubjectService getSubjectService()
    {
        return subjectService;
    }

    @Override
    public TeacherService getTeacherService()
    {
        return teacherService;
    }

    @Override
    public UniversityService getUniversityService()
    {
        return universityService;
    }
}
