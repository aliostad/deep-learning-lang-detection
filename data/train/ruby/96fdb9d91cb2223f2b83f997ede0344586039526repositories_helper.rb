module RepositoriesHelper  
  def log_path(objectish = "master", options = {})
    if options.blank? # just to avoid the ? being tacked onto the url
      project_repository_log_path(@project, @repository, objectish)
    else
      project_repository_log_path(@project, @repository, objectish, options)
    end
  end
  
  def commit_path(objectish = "master")
    project_repository_commit_path(@project, @repository, objectish)
  end
  
  def tree_path(treeish = "master", path=[])
    project_repository_tree_path(@project, @repository, treeish, path)
  end
  
  def archive_tree_path(treeish = "master")
    project_repository_archive_tree_path(@project, @repository, treeish)
  end
  
  def repository_path(action, sha1=nil)
    project_repository_path(@project, @repository)+"/"+action+"/"+sha1.to_s
  end
  
  def blob_path(sha1, path)
    project_repository_blob_path(@project, @repository, sha1, path)
  end
  
  def raw_blob_path(sha1, path)
    project_repository_raw_blob_path(@project, @repository, sha1, path)
  end
end
