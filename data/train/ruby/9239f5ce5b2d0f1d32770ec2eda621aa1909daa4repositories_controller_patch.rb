module OpenProject::Revisions
  module Patches
    module RepositoriesControllerPatch

      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

          alias_method_chain :edit,  :revisions
          alias_method_chain :destroy, :revisions
        end
      end

      module InstanceMethods

        def edit_with_revisions(&block)

          # Check if repository has been created before
          @repository = @project.repository
          if !@repository
            @repository = Repository.factory(params[:repository_scm])
            @repository.project = @project if @repository
          end

          # Allow plugins to modify requests (i.e., set repo URL)
          call_hook(:repository_edit_request, :repository => @repository)

          edit_without_revisions(&block)

          if request.post? && !@repository.errors.any?
            call_hook(:repository_edited, :repository => @repository)
          end
        end


        def destroy_with_revisions(&block)
          destroy_without_revisions(&block)

          if !@repository.errors.any?
            call_hook(:repository_destroyed, :repository => @repository)
          end
        end

      end
    end
  end
end

RepositoriesController.send(:include, OpenProject::Revisions::Patches::RepositoriesControllerPatch)
