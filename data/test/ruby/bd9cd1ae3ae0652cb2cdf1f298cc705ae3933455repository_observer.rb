require 'fileutils'
require 'grit'
class RepositoryObserver < ActiveRecord::Observer
  observe Repository, TextRepository
  def before_create(repository)
    unless File.exist?("#{repository.working_dir}")
      repository.mkdir
    end
  end

  def after_create(repository)
    repository.git_init
    branch = repository.branches.create(name:"master", bare:true)
    branch.posts.create(title:"README", body:"README")
    branch.build_kommit(message:"First Commit(README)").save
    RepositoryCreateNews.create(repository_id:repository, user_id:repository.user)
  end

  def before_destroy(repository)
    FileUtils.rm_r(repository.working_dir, {force:true})
  end
end
