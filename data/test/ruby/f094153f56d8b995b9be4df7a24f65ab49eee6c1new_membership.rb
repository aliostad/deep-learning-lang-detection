class UserShowPage
  class NewMembership
    attr_accessor :user, :roles_repository, :user_memberships_repository,
      :user_roles_repository, :projects_repository

    def initialize(user:, roles_repository:, user_memberships_repository:,
                   user_roles_repository:, projects_repository:)
      self.user = user
      self.roles_repository = roles_repository
      self.user_memberships_repository = user_memberships_repository
      self.user_roles_repository = user_roles_repository
      self.projects_repository = projects_repository
    end

    def membership
      user_memberships_repository.build(role: user_roles.first)
    end

    def user_billable?
      user.primary_role.try(:billable?)
    end

    def active_projects
      projects_repository.active_sorted
    end

    def available_projects
      projects_repository.available_sorted
    end

    def available_roles
      @available_roles ||= roles_repository.all
    end

    def user_primary_role_id
      user.primary_role.try(:id)
    end

    def user_roles
      @user_roles ||= user_roles_repository.all
    end
  end
end
