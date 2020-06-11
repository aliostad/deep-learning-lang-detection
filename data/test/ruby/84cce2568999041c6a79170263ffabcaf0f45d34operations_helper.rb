module OperationsHelper

  def new_operation_path(project, repository)
    if (project == repository)
      [:new, repository, :operation]
    else
      [:new, project, repository, :operation]
    end
  end

  def operations_path(project, repository)
    if (project == repository)
      [repository, :operation]
    else
      [project, repository, :operations]
    end
  end

  def operation_path(project, repository, operation)
    if (project == repository)
      [repository, operation]
    else
      [project, repository, operation]
    end
  end

  def edit_operation_path(project, repository, operation)
    if (project == repository)
      [:edit, repository, operation]
    else
      [:edit, project, repository, operation]
    end
  end
end
