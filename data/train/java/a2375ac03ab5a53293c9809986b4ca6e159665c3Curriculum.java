package com.reodeveloper.curriculum.domain;

import com.reodeveloper.curriculum.common.repository.Repository;
import java.util.List;

public class Curriculum {
  private final Repository<Job> jobsRepository;
  private final Repository<Education> educationRepository;
  private final Repository<Project> projectRepository;

  public Curriculum(Repository<Education> educationRepository, Repository<Job> jobsRepository,
      Repository<Project> projectRepository) {
    this.educationRepository = educationRepository;
    this.jobsRepository = jobsRepository;
    this.projectRepository = projectRepository;
  }

  public List<Job> getJobs() {
    return jobsRepository.getAll();
  }

  public void addJob(Job item) {
    jobsRepository.add(item);
  }

  public List<Education> getEducation() {
    return educationRepository.getAll();
  }

  public void addEducation(Education item) {
    educationRepository.add(item);
  }

  public List<Project> getProjects() {
    return projectRepository.getAll();
  }

  public void addProject(Project item) {
    projectRepository.add(item);
  }
}
