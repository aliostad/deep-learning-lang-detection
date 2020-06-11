module GitlabGateway
  module Clients
    module V3
      class Repositories < GitlabGateway::Client

        get :repository_branches, "/api/v3/projects/:id/repository/branches" do |resource|
          resource.required :id
        end

        get :repository_branch, "/api/v3/projects/:id/repository/branches/:branch" do |resource|
          resource.required :id, :branch
        end

        put :protect_repository_branch, "/api/v3/projects/:id/repository/branches/:branch/protect" do |resource|
          resource.required :id, :branch
        end

        put :unprotect_repository_branch, "/api/v3/projects/:id/repository/branches/:branch/unprotect" do |resource|
          resource.required :id, :branch
        end

        get :repository_tags, "/api/v3/projects/:id/repository/tags" do |resource|
          resource.required :id
        end

        get :repository_commits, "/api/v3/projects/:id/repository/commits" do |resource|
          resource.required :id

          resource.optional :ref_name
        end

        get :repository_tree, "/api/v3/projects/:id/repository/tree" do |resource|
          resource.required :id

          resource.optional :path, :ref_name
        end

        get :repository_blob_content, "/api/v3/projects/:id/repository/commits/:sha/blob" do |resource|
          resource.required :id, :sha, :filepath
        end
      end
    end
  end
end
