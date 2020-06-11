class ExternalMemory::WebServer

  type 'ApiSources',
       {
         :properties => {
           :apiSources => {
             :type => ['Source'],
             :description => 'A list of api sources',
           }
         },
         :required => [:apiSources],
       }

  type 'ApiSourceIn',
       {
         :properties => swagger_properties(Source::MODEL_INFO, [:name]),
         :required => [:name],
       }

  type 'ApiSourceRoot',
       {
         :properties => {
           :apiSource => {
             :type => 'Source',
             :description => 'An api source',
           }
         },
         :required => [:apiSource],
       }

  endpoint_tags 'api'
  endpoint_summary 'Create a new API source'
  endpoint_response 201, 'ApiSourceRoot'
  endpoint_response 400, 'Error', 'In case of error'
  endpoint_parameter :apiSource, 'An api source', :body, true, 'ApiSourceIn'
  declare_authentication
  post '/api/api/source' do
    create_api_source
  end

  endpoint_tags 'api'
  endpoint_summary 'Update an API source'
  endpoint_response 200, 'ApiSourceRoot'
  endpoint_response 404, 'Error', 'If the API source is not found'
  endpoint_response 400, 'Error', 'In case of error'
  endpoint_path '/api/api/source/{source_id}'
  endpoint_parameter :apiSource, 'An api source', :body, true, 'ApiSourceIn'
  endpoint_parameter :source_id, Source::MODEL_INFO[:id][:description], :path, true, Integer
  declare_authentication
  put %r{/api/api/source/(?<source_id>\d+)\z} do |source_id|
    update_api_source(source_id)
  end

  endpoint_tags 'api'
  endpoint_summary 'List API sources'
  endpoint_response 200, 'ApiSources'
  declare_authentication
  get '/api/api/source' do
    list_api_sources
  end

  endpoint_tags 'api'
  endpoint_summary 'Get a source API by its id'
  endpoint_response 200, 'ApiSourceRoot'
  endpoint_response 404, 'Error', 'If the API source is not found'
  endpoint_response 400, 'Error', 'In case of error'
  endpoint_parameter :source_id, Source::MODEL_INFO[:id][:description], :path, true, Integer
  endpoint_path '/api/api/source/{source_id}'
  declare_authentication
  get %r{/api/api/source/(?<source_id>\d+)\z} do |source_id|
    get_api_source_by_id(source_id)
  end

end
