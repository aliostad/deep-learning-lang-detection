/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.heinvdende.versionreview.test.modules.repository.persistence.factory;

import com.heinvdende.versionreview.test.modules.repository.persistence.AbstractRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.CodeFileRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.FileChangeRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.MemberRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.ProjectRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.TaskClassRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.TaskRepository;
import com.heinvdende.versionreview.test.modules.repository.persistence.UserRepository;

/**
 *
 * @author Heinrich
 */
public class RepositoryFactory {
    
    
    
    // Repositories
    public CodeFileRepository getCodeFileRepository() {
        return (CodeFileRepository) instantiateDAO(CodeFileRepository.class); 
    }
    
    public FileChangeRepository getFileChangeRepository() {
        return (FileChangeRepository) instantiateDAO(FileChangeRepository.class);
    }
    
    public MemberRepository getMemberRepository() {
        return (MemberRepository) instantiateDAO(MemberRepository.class);
    }
    
    public ProjectRepository getProjectRepository() {
        return (ProjectRepository) instantiateDAO(ProjectRepository.class);
    }
    
    public TaskClassRepository getTaskClassRepository() {
        return (TaskClassRepository) instantiateDAO(TaskClassRepository.class);
    }
    
    public TaskRepository getTaskRepository() {
        return (TaskRepository) instantiateDAO(TaskRepository.class);
    }
    
    public UserRepository getUserRepository() {
        return (UserRepository) instantiateDAO(UserRepository.class);
    }
    
    private AbstractRepository instantiateDAO(Class daoClass) {  
        try {  
            AbstractRepository dao = (AbstractRepository) daoClass.newInstance();  
            // Open Session for DAO
            dao.openSession();
            // Start and set Transaction after session is opened
            dao.setTransaction(dao.getSession().beginTransaction());
            
            return dao;  
        } catch (Exception ex) {  
            throw new RuntimeException("Can not instantiate DAO: " + daoClass, ex);  
        }  
    }  
}
