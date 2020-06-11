module ApplicationHelper
  def all_repositories
    Repository.all
  end

  def all_users
    User.all
  end

  def repositories_controller?
    controller.controller_name == 'repositories'
  end

  def users_controller?
    controller.controller_name == 'users'
  end

  def statistics_controller?
    controller.controller_name.starts_with? 'statistics'
  end

  def settings_controller?
    controller.controller_name.starts_with? 'settings'
  end

  def system_controller?
    controller.controller_name.starts_with? 'system'
  end

  def projects_controller?
    %w(projects tasks versions).any? { |name| controller.controller_name.starts_with? name }
  end

  def human_boolean(bool)
    bool ? I18n.t('Yes') : I18n.t('No')
  end

  def locales_for_select
    [%w(English en), %w(Deutsch de)]
  end
end
