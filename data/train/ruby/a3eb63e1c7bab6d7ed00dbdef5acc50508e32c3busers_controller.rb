require 'securerandom'

class Repositories::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :_check_viewer
  before_action :_check_editor, only: [:new, :create, :destroy]

  include RepositoriesHelper

  def index
    @buttons = [
        {label: t('links.repository.list', name: @repository.name), url: repositories_path, style: 'warning'},

    ]
    if repositories_can_edit?
      @buttons.unshift({label: t('links.repository.user.create', name: @repository.name), url: new_repository_user_path, style: 'primary'})
    end

    @users = []
    User.with_any_role({name: :reader, resource: @repository}).each do |u|
      @users << {cols: [u.label, 'R', u.contact], url: repository_user_path(u.id, repository_id: @repository.id)}
    end
    User.with_any_role({name: :writer, resource: @repository}).each do |u|
      @users << {cols: [u.label, 'RW', u.contact], url: repository_user_path(u.id, repository_id: @repository.id)}
    end
  end


  def create

    uid = params[:user_id]
    success = false

    if uid && uid != current_user.id
      user = User.find uid
      if user
        user.add_role (params[:readonly] == 'false' ? :writer : :reader), @repository
        # c = Confirmation.create extra: {
        #     repository_id: @repository.id,
        #     type: :add_to_repository,
        #     from: repository_url(@repository.id)
        # }.to_json,
        #                         subject:t('mails.add_to_repository.subject', name:@repository.name),
        #                         user_id: user.id, token: SecureRandom.uuid, deadline: 1.days.since
        # UserMailer.delay.confirm(c.id)
        GitAdminJob.perform_later
        success = true
      end
    end

    if success
      flash[:notice] = t('labels.success')
      redirect_to(repository_users_path(@repository))
    else
      flash[:alert] = t('labels.not_valid')
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    @user.remove_role(:reader, @repository) if @user.is_reader_of?(@repository)
    @user.remove_role(:writer, @repository) if @user.is_writer_of?(@repository)

    GitAdminJob.perform_later
    UserMailer.delay.remove_from_repository(repository_id: @repository.id, user_id: @user.id)
    redirect_to repository_users_path(repository_id: @repository.id)
  end


  private
  def _check_viewer
    @repository = Repository.find params[:repository_id]
    unless repositories_can_view?
      render status: 404
    end
  end

  def _check_editor
    unless repositories_can_edit?
      render status: 404
    end
  end

end

