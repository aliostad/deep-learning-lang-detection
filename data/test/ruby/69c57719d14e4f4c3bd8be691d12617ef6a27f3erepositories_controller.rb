class RepositoriesController < ApplicationController
  load_and_authorize_resource :user, class: 'User'
  load_and_authorize_resource through: :user

  def list
    unless params[:enabled].nil?
      @repositories = @repositories.where(enabled: (params[:enabled] == 'true'))
    end
    render json: @repositories.to_json
  end

  def sync
    current_user.sync_repositories
    return_json(true, 'Repositories synced')
  end

  def enable
    sync_repo
    @repository.enabled = true
    @repository.save
    return_json(true, message: 'Repository enabled', data: @repository)
  end

  def disable
    @repository.enabled = false
    @repository.save
    return_json(true, message: 'Repository disabled', data: @repository)
  end

  def refresh
    sync_repo
    return_json(true, message: 'Repository refreshing', data: @repository)
  end

  private
  def reset
    @repository = Repository.new
    @repositories = Repository.none
  end


  def sync_repo
    status = if @repository.processing.nil?
               nil
             else
               Sidekiq::Status::status(@repository.processing)
             end
    if status.nil? or status.complete? or status.failed?
      job_id = RepositoryPreprocessorWorker.perform_async(@repository.id)
      @repository.sync_at = Time.now
      @repository.processing = job_id
      @repository.save
    end
  end
end
