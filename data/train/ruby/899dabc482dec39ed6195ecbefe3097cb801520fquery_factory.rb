require 'util/string'
require 'query/prototype/query'

module PaynetEasy::PaynetEasyApi::Query
  class QueryFactory
    # Create API query object by API query method
    #
    # @param    api_query_name    [String]              API query method name
    #
    # @return                     [Prototype::Query]    API query object
    def query(api_query_name)
      query_class = "#{api_query_name.camelize}Query"
      query_file  = "query/#{api_query_name.gsub('-', '_')}_query"

      require query_file
      PaynetEasy::PaynetEasyApi::Query.const_get(query_class).new(api_query_name)
    end
  end
end