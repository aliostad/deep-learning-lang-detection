package com.temenos.t24.tools.eclipse.basic.rtc;

import java.util.Arrays;
import java.util.List;

import org.eclipse.core.runtime.IProgressMonitor;

import com.ibm.team.repository.client.ITeamRepository;
import com.ibm.team.repository.client.TeamPlatform;
import com.ibm.team.repository.common.TeamRepositoryException;

public class RepositoryManager {

    private static RepositoryManager INSTANCE = new RepositoryManager();
    private IProgressMonitor monitor = new SysoutProgressMonitor();

    private RepositoryManager() {
    }

    public static RepositoryManager getInstance() {
        return INSTANCE;
    }

    public List<ITeamRepository> getRepositories() {
        ITeamRepository[] iTeamRepositoryArray = TeamPlatform.getTeamRepositoryService().getTeamRepositories();
        List<ITeamRepository> iTeamRepositories;
        iTeamRepositories = Arrays.asList(iTeamRepositoryArray);
        return iTeamRepositories;
    }

    public ITeamRepository login(final String repositoryURI, final String userName, final String passWord) {
        ITeamRepository repository = TeamPlatform.getTeamRepositoryService().getTeamRepository(repositoryURI);
        repository.registerLoginHandler(new ITeamRepository.ILoginHandler() {

            public ILoginInfo challenge(ITeamRepository repository) {
                return new ILoginInfo() {

                    public String getUserId() {
                        return userName;
                    }

                    public String getPassword() {
                        return passWord;
                    }
                };
            }
        });
        monitor.subTask("Login in progress...");
        try {
            repository.login(monitor);
        } catch (TeamRepositoryException e) {
            monitor.subTask("Unable to login. " + e.getMessage());
            return null;
        }
        monitor.subTask("Connected");
        return repository;
    }

    public String getRepositoryURI(String repositoryName) {
        return null;
    }

    public boolean isLoggedIn(String repositoryURI) {
        ITeamRepository repository = TeamPlatform.getTeamRepositoryService().getTeamRepository(repositoryURI);
        return repository.loggedIn();
    }
}
