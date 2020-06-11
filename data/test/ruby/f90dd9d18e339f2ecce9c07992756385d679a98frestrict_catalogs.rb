require "restrict_catalogs/version"

module RestrictCatalogs
  class RestrictCatalogsFeatureDefinition
    include FeatureSystem::Provides
    def permissions
      [
        {
          can: true,
          callback_name: 'can_manage_catalog_claims',
          name: 'Can Manage Catalog Groups'
        }
      ]
    end
  end

  module Authorization
    module Permissions
      def can_manage_catalog_claims
        can :manage, CatalogClaim
      end
    end
  end

end

require 'restrict_catalogs/railtie' if defined?(Rails)
