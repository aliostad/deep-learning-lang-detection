module SwaggerYard
  class ResourceListing
    attr_reader :api_declarations

    def initialize
      @api_declarations = []
    end

    def add(api_declaration)
      @api_declarations << api_declaration
    end

    def to_h
      { 
        "apiVersion"     => SwaggerYard.api_version,
        "swaggerVersion" => SwaggerYard.swagger_version,
        "basePath"       => SwaggerYard.doc_base_path,
        "apis"           => list_api
      }
    end

  private
    def list_api
      @api_declarations.map do |api_declaration|
        {
          "path"        => api_declaration.resource_path,
          "description" => api_declaration.description
        }
      end.sort_by { |hsh| hsh["path"] }
    end
  end
end