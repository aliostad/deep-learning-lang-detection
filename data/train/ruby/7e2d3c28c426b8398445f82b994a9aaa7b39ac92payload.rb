module Fast
  class Payload
    def initialize(payload)
      @payload = payload      
    end
    
    def [](k)
      @payload[k]
    end
        
    def repository
      @repository ||= Repository.new(@payload["repository"])
    end
    
    class Repository
      def initialize(repository)
        @repository = repository
      end
      
      def [](k)
        @repository[k]
      end
      
      def id 
        @repository["id"]
      end
      
      def full_name
        @full_name ||= @repository["full_name"] || parse_full_name_from_url
      end
      
      def url
        @repository["html_url"] || @repository["url"]
      end
      
      private 
      
      def parse_full_name_from_url
        URI.parse(url).path[1..-1]
      end
    end
  end
end
