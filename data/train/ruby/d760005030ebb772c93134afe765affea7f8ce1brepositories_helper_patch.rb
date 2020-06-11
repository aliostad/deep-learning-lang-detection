module PrivateRepository
  module RepositoriesHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :repository_field_tags, :private_repository
      end
    end

    module InstanceMethods
      def repository_field_tags_with_private_repository(form, repository)
        if repository.class.name != 'repository'
          repository_field_tags_without_private_repository(form, repository) +
              content_tag('p', form.check_box(
                  :is_private,
                  :label => l(:field_is_private)
              ))
        end
      end
    end
  end
end