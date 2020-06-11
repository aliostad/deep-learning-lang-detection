module Reminders
  class SyncProjects
    attr_accessor :reminder, :projects_repository, :project_checks_repository

    def initialize(reminder, projects_repository = ProjectsRepository.new,
                   project_checks_repository = ProjectChecksRepository.new)
      self.reminder = reminder
      self.projects_repository = projects_repository
      self.project_checks_repository = project_checks_repository
    end

    def call
      missing_projects.each do |project|
        pc = ProjectCheck.new(project_id: project.id,
                              reminder_id: reminder.id,
                              enabled: project.enabled,
                             )
        project_checks_repository.create pc
      end
    end

    private

    def missing_projects
      @missing_projects = projects_repository.all -
                          projects_repository.for_reminder(reminder)
    end
  end
end
