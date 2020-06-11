class RepositoryObserver < ActiveRecord::Observer

    def before_destroy(repository)
        if repository.created_with_scm
            project   = repository.project
            interface = SCMCreator.interface(repository)
            if interface

                name = interface.repository_name(repository.root_url)
                if name
                    path = interface.existing_path(name, repository)
                    if path
                        interface.execute(ScmConfig['pre_delete'], path, project) if ScmConfig['pre_delete']
                        interface.delete_repository(path)
                        interface.execute(ScmConfig['post_delete'], path, project) if ScmConfig['post_delete']
                    end
                end
            end

        end
    end

end
