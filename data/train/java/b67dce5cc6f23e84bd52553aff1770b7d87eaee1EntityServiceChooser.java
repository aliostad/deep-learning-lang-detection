package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import service.BaseService;
import service.Impl.*;

/**
 * Created by Administrator on 29.07.2014.
 */

@Component
public class EntityServiceChooser {

    @Autowired
    AdminServiceImpl adminService;

    @Autowired
    CertificateServiceImpl certificateService;

    @Autowired
    CourseServiceImpl courseService;

    @Autowired
    CuratorServiceImpl curatorService;

    @Autowired
    CustomFieldServiceImpl customFieldService;

    @Autowired
    FacultyServiceImpl facultyService;

    @Autowired
    FeedbackServiceImpl feedbackService;

    @Autowired
    FieldsGroupServiceImpl fieldsGroupService;

    @Autowired
    GroupServiceImpl groupService;

    @Autowired
    HRServiceImpl hrService;

    @Autowired
    InterviewServiceImpl interviewService;

    @Autowired
    InterviewerServiceImpl interviewerService;

    @Autowired
    MarksServiceImpl marksService;

    @Autowired
    PMServiceImpl pmService;

    @Autowired
    ProjectServiceImpl projectService;

    @Autowired
    SettingServiceImpl settingService;

    @Autowired
    StudentServiceImpl studentService;

    @Autowired
    StudentCertificateServiceImpl studentCertificateService;

    @Autowired
    StudentCuratorServiceImpl studentCuratorService;

    @Autowired
    StudentCustomFieldServiceImpl studentCustomFieldService;

    @Autowired
    StudentGroupServiceImpl studentGroupService;

    @Autowired
    StudentProjectServiceImpl studentProjectService;

    @Autowired
    TeamLeaderServiceImpl teamLeaderService;

    @Autowired
    TechnologyServiceImpl technologyService;

    @Autowired
    TechnologyStudentFutureServiceImpl technologyStudentFutureService;

    @Autowired
    TechnologyStudentNowServiceImpl technologyStudentNowService;

    @Autowired
    UniversityServiceImpl universityService;

    @Autowired
    UserServiceImpl userService;

    public BaseService serviceChooser(String entity){
        if(entity.equalsIgnoreCase("admin"))
            return adminService;
        if(entity.equalsIgnoreCase("certificate"))
            return certificateService;
        if(entity.equalsIgnoreCase("course"))
            return courseService;
        if(entity.equalsIgnoreCase("curator"))
            return curatorService;
        if(entity.equalsIgnoreCase("customfield"))
            return customFieldService;
        if(entity.equalsIgnoreCase("faculty"))
            return facultyService;
        if(entity.equalsIgnoreCase("feedback"))
            return feedbackService;
        if(entity.equalsIgnoreCase("fieldsgroup"))
            return fieldsGroupService;
        if(entity.equalsIgnoreCase("group"))
            return groupService;
        if(entity.equalsIgnoreCase("hr"))
            return hrService;
        if(entity.equalsIgnoreCase("interview"))
            return interviewService;
        if(entity.equalsIgnoreCase("interviewer"))
            return interviewerService;
        if(entity.equalsIgnoreCase("marks"))
            return marksService;
        if (entity.equalsIgnoreCase("pm"))
            return pmService;
        if(entity.equalsIgnoreCase("project"))
            return projectService;
        if(entity.equalsIgnoreCase("setting"))
            return settingService;
        if (entity.equalsIgnoreCase("student"))
            return studentService;
        if(entity.equalsIgnoreCase("studentcertificate"))
            return studentCertificateService;
        if (entity.equalsIgnoreCase("studentcurator"))
            return studentCuratorService;
        if (entity.equalsIgnoreCase("studentcustomfield"))
            return studentCustomFieldService;
        if (entity.equalsIgnoreCase("studentgroup"))
            return studentGroupService;
        if (entity.equalsIgnoreCase("studentproject"))
            return studentProjectService;
        if (entity.equalsIgnoreCase("teamleader"))
            return teamLeaderService;
        if (entity.equalsIgnoreCase("technology"))
            return technologyService;
        if (entity.equalsIgnoreCase("technologystudentfuture"))
            return technologyStudentFutureService;
        if (entity.equalsIgnoreCase("technologystudentnow"))
            return technologyStudentNowService;
        if (entity.equalsIgnoreCase("university"))
            return universityService;
        if (entity.equalsIgnoreCase("user"))
            return userService;
        return null;
    }

    public void setAdminService(AdminServiceImpl adminService) {
        this.adminService = adminService;
    }

    public void setCertificateService(CertificateServiceImpl certificateService) {
        this.certificateService = certificateService;
    }

    public void setCourseService(CourseServiceImpl courseService) {
        this.courseService = courseService;
    }

    public void setCuratorService(CuratorServiceImpl curatorService) {
        this.curatorService = curatorService;
    }

    public void setCustomFieldService(CustomFieldServiceImpl customFieldService) {
        this.customFieldService = customFieldService;
    }

    public void setFacultyService(FacultyServiceImpl facultyService) {
        this.facultyService = facultyService;
    }

    public void setFeedbackService(FeedbackServiceImpl feedbackService) {
        this.feedbackService = feedbackService;
    }

    public void setFieldsGroupService(FieldsGroupServiceImpl fieldsGroupService) {
        this.fieldsGroupService = fieldsGroupService;
    }

    public void setGroupService(GroupServiceImpl groupService) {
        this.groupService = groupService;
    }

    public void setHrService(HRServiceImpl hrService) {
        this.hrService = hrService;
    }

    public void setInterviewService(InterviewServiceImpl interviewService) {
        this.interviewService = interviewService;
    }

    public void setInterviewerService(InterviewerServiceImpl interviewerService) {
        this.interviewerService = interviewerService;
    }

    public void setMarksService(MarksServiceImpl marksService) {
        this.marksService = marksService;
    }

    public void setPmService(PMServiceImpl pmService) {
        this.pmService = pmService;
    }

    public void setProjectService(ProjectServiceImpl projectService) {
        this.projectService = projectService;
    }

    public void setSettingService(SettingServiceImpl settingService) {
        this.settingService = settingService;
    }

    public void setStudentService(StudentServiceImpl studentService) {
        this.studentService = studentService;
    }

    public void setStudentCertificateService(StudentCertificateServiceImpl studentCertificateService) {
        this.studentCertificateService = studentCertificateService;
    }

    public void setStudentCuratorService(StudentCuratorServiceImpl studentCuratorService) {
        this.studentCuratorService = studentCuratorService;
    }

    public void setStudentCustomFieldService(StudentCustomFieldServiceImpl studentCustomFieldService) {
        this.studentCustomFieldService = studentCustomFieldService;
    }

    public void setStudentGroupService(StudentGroupServiceImpl studentGroupService) {
        this.studentGroupService = studentGroupService;
    }

    public void setStudentProjectService(StudentProjectServiceImpl studentProjectService) {
        this.studentProjectService = studentProjectService;
    }

    public void setTeamLeaderService(TeamLeaderServiceImpl teamLeaderService) {
        this.teamLeaderService = teamLeaderService;
    }

    public void setTechnologyService(TechnologyServiceImpl technologyService) {
        this.technologyService = technologyService;
    }

    public void setTechnologyStudentFutureService(TechnologyStudentFutureServiceImpl technologyStudentFutureService) {
        this.technologyStudentFutureService = technologyStudentFutureService;
    }

    public void setTechnologyStudentNowService(TechnologyStudentNowServiceImpl technologyStudentNowService) {
        this.technologyStudentNowService = technologyStudentNowService;
    }

    public void setUniversityService(UniversityServiceImpl universityService) {
        this.universityService = universityService;
    }

    public void setUserService(UserServiceImpl userService) {
        this.userService = userService;
    }


}
