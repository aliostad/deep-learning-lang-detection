module API
  module V1
    # API Root for V1
    class Root < Grape::API
      format :json

      before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
      end

      api_version_url = '/api/v1'

      mount API::V1::Bestiaries => api_version_url
      mount API::V1::Monsters => api_version_url

      # add_swagger_documentation mount_path: '/api/doc',
      #                           api_version: 'v1',
      #                           markdown: true,
      #                           hide_documentation_path: true,
      #                           base_path: Application.config.base_path
    end
  end
end
