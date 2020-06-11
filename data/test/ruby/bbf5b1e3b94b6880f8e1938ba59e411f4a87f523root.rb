module API
  module V1
    class Root < Grape::API
      version 'v1'
      format :json
      default_format :json

      mount API::V1::TokenAPI
      mount API::V1::AccountAPI
      mount API::V1::ProjectAPI
      mount API::V1::AssignmentAPI
      mount API::V1::AssignmentRoleAPI
      mount API::V1::CloudAPI
      mount API::V1::BaseImageAPI
      mount API::V1::BlueprintAPI
      mount API::V1::BlueprintHistoryAPI
      mount API::V1::BlueprintPatternAPI
      mount API::V1::PatternAPI
      mount API::V1::SystemAPI
      mount API::V1::EnvironmentAPI
      mount API::V1::EventAPI
      mount API::V1::ApplicationAPI
      mount API::V1::ApplicationHistoryAPI
      mount API::V1::RoleAPI
      mount API::V1::PermissionAPI
      mount API::V1::AuditAPI
    end
  end
end
