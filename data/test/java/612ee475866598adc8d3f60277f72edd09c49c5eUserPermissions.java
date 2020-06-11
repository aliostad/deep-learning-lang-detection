package com.photon.phresco.commons.model;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;

@XmlRootElement
@JsonIgnoreProperties(ignoreUnknown = true)
public class UserPermissions implements Serializable  {

	private static final long serialVersionUID = 1L;

	public UserPermissions() {
		super();
	}

	private boolean manageApplication;
    private boolean importApplication;
    private boolean manageRepo;
    private boolean updateRepo;
    private boolean managePdfReports;
    private boolean manageCodeValidation;
    private boolean manageConfiguration;
    private boolean manageBuilds;
    private boolean manageTests;
    private boolean manageCIJobs;
    private boolean executeCIJobs;
    private boolean manageMavenReports;
    private boolean viewRepo;
    private boolean manageDash;
    private boolean releseRepo;
  
	public boolean isManageApplication() {
		return manageApplication;
	}

	public void setManageApplication(boolean manageApplication) {
		this.manageApplication = manageApplication;
	}

	public boolean isImportApplication() {
		return importApplication;
	}

	public void setImportApplication(boolean importApplication) {
		this.importApplication = importApplication;
	}

	public boolean isManageRepo() {
		return manageRepo;
	}

	public void setManageRepo(boolean manageRepo) {
		this.manageRepo = manageRepo;
	}

	public boolean isUpdateRepo() {
		return updateRepo;
	}

	public void setUpdateRepo(boolean updateRepo) {
		this.updateRepo = updateRepo;
	}

	public boolean isManagePdfReports() {
		return managePdfReports;
	}

	public void setManagePdfReports(boolean managePdfReports) {
		this.managePdfReports = managePdfReports;
	}

	public boolean isManageCodeValidation() {
		return manageCodeValidation;
	}

	public void setManageCodeValidation(boolean manageCodeValidation) {
		this.manageCodeValidation = manageCodeValidation;
	}

	public boolean isManageConfiguration() {
		return manageConfiguration;
	}

	public void setManageConfiguration(boolean manageConfiguration) {
		this.manageConfiguration = manageConfiguration;
	}

	public boolean isManageBuilds() {
		return manageBuilds;
	}

	public void setManageBuilds(boolean manageBuilds) {
		this.manageBuilds = manageBuilds;
	}

	public boolean isManageTests() {
		return manageTests;
	}

	public void setManageTests(boolean manageTests) {
		this.manageTests = manageTests;
	}

	public boolean isManageCIJobs() {
		return manageCIJobs;
	}

	public void setManageCIJobs(boolean manageCIJobs) {
		this.manageCIJobs = manageCIJobs;
	}

	public boolean isExecuteCIJobs() {
		return executeCIJobs;
	}

	public void setExecuteCIJobs(boolean executeCIJobs) {
		this.executeCIJobs = executeCIJobs;
	}

	public boolean isManageMavenReports() {
		return manageMavenReports;
	}

	public void setManageMavenReports(boolean manageMavenReports) {
		this.manageMavenReports = manageMavenReports;
	}
	
	public boolean isViewRepo() {
		return viewRepo;
	}

	public void setViewRepo(boolean viewRepo) {
		this.viewRepo = viewRepo;
	}
	
	public boolean isManageDash() {
		return manageDash;
	}

	public void setManageDash(boolean manageDash) {
		this.manageDash = manageDash;
	}

	public boolean isReleseRepo() {
		return releseRepo;
	}

	public void setReleseRepo(boolean releseRepo) {
		this.releseRepo = releseRepo;
	}

	public String toString() {
        return new ToStringBuilder(this,
                ToStringStyle.DEFAULT_STYLE)
                .append(super.toString())
                .append("manageApplication", isManageApplication())
                .append("importApplication", isImportApplication())
                .append("manageRepo", isManageRepo())
                .append("updateRepo", isUpdateRepo())
                .append("managePdfReports", isManagePdfReports())
                .append("manageCodeValidation", isManageCodeValidation())
                .append("manageConfiguration", isManageConfiguration())
                .append("manageBuilds", isManageBuilds())
                .append("manageTests", isManageTests())
                .append("manageCIJobs", isManageCIJobs())
                .append("executeCIJobs", isExecuteCIJobs())
                .append("manageMavenReports", isManageMavenReports())
                .append("viewRepo",isViewRepo())
                .append("manageDash",isManageDash())
                .append("createRepo",isReleseRepo())
                .toString();
    }
}