class RepositoriesController < ApplicationController
  before_filter :login_required, :except => [:history, :diff_to]
  before_filter :load_repository, :except => [:new_for_parent, :create_for_parent, :diff_to]

  def new_for_parent
    @parent_repository = Repository.find params[:parent_repo_id]
  end

  def create_for_parent
    parent_repository = Repository.find params[:parent_repo_id]
    new_repository = Repository.create! do |r|
      r.parent = parent_repository
      r.name = params[:name]
      r.user = current_user
      r.can_changed_by = params[:can_changed_by]
    end
    flash[:notice] = "Zweig erstellt"
    redirect_to repo_view_path new_repository
  end

  def edit
  end

  def update
    @repository.content = params[:content]
    @repository.commit_message = "Changed by #{current_user.login} (#{params[:commit_message]})"
    @repository.save!
    redirect_to repo_view_path @repository
  end

  def history
    @history = @repository.git.log
  end

  def merge_parent
    @repository.merge_parent
    redirect_to repo_view_path @repository
  end

  def merge_child
    @repository.merge_child params[:child_id].to_i
    redirect_to repo_view_path @repository
  end

  def diff_to
    @repository = Repository.find params[:id]
    diff = @repository.diff_to params[:to_id].to_i
    diff_str = diff.to_s
    diff_lines = (diff_str.split("\n").collect{|st| st.strip})[4..-1]
    @src_name = @repository.name
    @dst_name = Repository.find(params[:to_id].to_i).name
    @diff_lines = (diff_lines.nil? ? [] : diff_lines.collect{|l| DiffLine.new l})
  end

  protected

  def load_repository
    @repository = Repository.find params[:id]
    access_denied unless @repository.write_access_for? current_user
  end
end

