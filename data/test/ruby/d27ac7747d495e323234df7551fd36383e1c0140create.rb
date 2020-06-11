module Dydra
  class Command
    ##
    # Creates a new repository.
    class Create < Command
      ##
      # @param  [Array<String>] repository_specs
      # @return [void]
      def execute(*repositories)
        puts "No repository specified" if repositories.empty?
        repositories.each do |repository|
          begin
            Repository.create!(repository)
            puts "#{repository} created."
          rescue RestClient::Forbidden
            puts "Insufficient permissions to create #{repository}."
          rescue RestClient::UnprocessableEntity
            puts "#{repository} already exists."
          rescue AuthenticationError => e
            puts e
          rescue RepositoryMisspecified => e
            puts e
          end
        end
      end
    end # Create
  end # Command
end # Dydra
