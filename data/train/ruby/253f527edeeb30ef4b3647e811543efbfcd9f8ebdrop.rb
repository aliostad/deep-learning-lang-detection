module Dydra
  class Command
    ##
    # Destroys a repository permanently.
    class Drop < Command
      ##
      # @param  [Array<String>] repository_specs
      # @return [void]
      def execute(*repositories)
        #repositories = validate_repository_specs(repository_specs)
        repositories.each do |repository|
          begin
            Repository.new(repository).destroy!
            puts "#{repository} deleted."
          rescue RestClient::ResourceNotFound
            puts "#{repository} not found."
          rescue RestClient::Forbidden
            puts "Insufficient permissions to delete #{repository}."
          rescue RepositoryMisspecified => e
            puts e
          end
        end
      end
    end # Drop
  end # Command
end # Dydra
