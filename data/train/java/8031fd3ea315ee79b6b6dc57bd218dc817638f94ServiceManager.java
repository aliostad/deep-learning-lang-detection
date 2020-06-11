package org.pollbox.poll.managers;

import org.pollbox.poll.accounts.AccountsService;
import org.pollbox.poll.owners.OwnersService;
import org.pollbox.poll.projects.ProjectsService;
import org.pollbox.poll.signup.SignupService;
import org.pollbox.poll.statuses.StatusesService;

import org.springframework.beans.factory.annotation.Autowired;


/**
 * Provides access to service classes that implements business logic.
 */
public class ServiceManager {
    @Autowired
    private SignupService signupService;
    
    @Autowired
    private OwnersService ownersService;

    @Autowired
    private AccountsService accountsService;
    
    @Autowired
    private StatusesService statusesService;
    
    @Autowired
    private ProjectsService projectsService;

    public StatusesService getStatusesService() {
        return statusesService;
    }

    public void setStatusesService(StatusesService statusesService) {
        this.statusesService = statusesService;
    }

    public AccountsService getAccountsService() {
        return accountsService;
    }

    public void setAccountsService(AccountsService accountsService) {
        this.accountsService = accountsService;
    }

    public OwnersService getOwnersService() {
        return ownersService;
    }

    public void setOwnersService(OwnersService ownersService) {
        this.ownersService = ownersService;
    }

    public ProjectsService getProjectsService() {
        return projectsService;
    }

    public void setProjectsService(ProjectsService projectsService) {
        this.projectsService = projectsService;
    }

    public SignupService getSignupService() {
        return signupService;
    }

    public void setSignupService(SignupService signupService) {
        this.signupService = signupService;
    }
}
