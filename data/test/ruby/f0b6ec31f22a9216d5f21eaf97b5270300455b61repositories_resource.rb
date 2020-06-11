require "pakada/repository/repository_form"

class Pakada::Repository
  class RepositoriesResource < Webmachine::Resource
    def initialize
      @repository = P.repository.repositories[repository_name]
    end

    def repository_name
      name = request.path_info[:name]
      name.to_sym if name
    end

    def resource_exists?
      !!@repository || !repository_name
    end

    def to_json
      MultiJson.encode("repository" => @repository.inspect)
    end

    def to_html
      dump = @repository.awesome_inspect.gsub(/\[[\d;]+m/, "")
      "<pre>#{CGI.escape_html(dump)}</pre>"
    end

    def to_form
      RepositoryForm.new(@repository) do |form|
        form.callback { ap "callback"; response.do_redirect(request.uri.path) }
        form.errback { ap "errback" }
      end
    end

    def content_types_provided
      [
        ["application/json", :to_json],
        ["text/html",        :to_html]
      ]
    end
  end
end
