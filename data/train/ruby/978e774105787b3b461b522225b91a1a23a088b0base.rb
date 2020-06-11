require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      mount API::V1::Home
      mount API::V1::Records
      mount API::V1::Comments
      mount API::V1::Auth
      mount API::V1::Users
      mount API::V1::Answers
      mount API::V1::QuestionBanks
      mount API::V1::WritingBanks
      mount API::V1::QuestionLists
      mount API::V1::WriteRecords
      mount API::V1::ThirdApies

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
