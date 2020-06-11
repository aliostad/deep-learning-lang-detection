class HookMailer < ActionMailer::Base
  default from: "no-reply@repotag.org"
  default to: "repotag@repotag.org"

  def activity_report(user, repository)
    @user = user
    @repository = repository
    mail(to: @user.email, subject: "[Repotag] Activity report for #{@repository.name}", delivery_method_options: Setting.get(:smtp_settings).settings )
  end

  def commit_details(user, repository, commit)
    @user = user
    @repository = repository
    @commit = commit
    mail(to: @user.email, subject: "[Repotag] Commit details for #{@repository.name}", delivery_method_options: Setting.get(:smtp_settings).settings )
  end

  def repository_created(user, repository)
    @user = user
    @repository = repository
    mail(to: @user.email, subject: "[Repotag] New repository #{@repository.name} created.", delivery_method_options: Setting.get(:smtp_settings).settings )
  end

end
