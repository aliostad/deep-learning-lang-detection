/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.perficient.rms.service.impl;

//import com.perficient.rms.service.EmployeeCertificationService;
import com.perficient.rms.service.AssignmentService;
import com.perficient.rms.service.EmailService;
import com.perficient.rms.service.EmployeeService;
import com.perficient.rms.service.FeedbackService;
import com.perficient.rms.service.PassportService;
import com.perficient.rms.service.ProjectService;
import com.perficient.rms.service.ResourceDictionaryService;
import com.perficient.rms.service.SkillCategoryService;
import com.perficient.rms.service.SkillService;

/**
 *
 * @author Shengli.Cao
 */
public final class ServiceFactory {

    private ServiceFactory() {
    }

    public static EmployeeService getEmployeeService() {
        return new EmployeeServiceImpl();
    }

    public static ProjectService getProjectService() {
        return new ProjectServiceImpl();
    }
    public static SkillService getSkillService() {
        return new SkillServiceImpl();
    }
    public static ResourceDictionaryService getResourceDictionaryService() {
        return new ResourceDictionaryServiceImpl();
    }

    public static SkillCategoryService getSkillCategoryService(){
        return new SkillCategoryServiceImpl();
    }
    public static AssignmentService getAssignmentService(){
        return new AssignmentServiceImpl();
    }
    
    public static EmailService getEmailService(){
        return new EmailServiceImpl();
    }
    
    public static FeedbackService getFeedbackService() {
    	return new FeedbackServiceImpl();
    }
    
    public static PassportService getPassportService() {
    	return new PassportServiceImpl();
    }
    
    public static VisaServiceImpl getVisaService() {
    	return new VisaServiceImpl();
    }
}
