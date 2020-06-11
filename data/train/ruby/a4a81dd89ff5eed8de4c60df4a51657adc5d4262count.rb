module Dydra
  class Command
    ##
    # Outputs the number of statements in a repository.
    class Count < Command
      ##
      # @param  [Array<String>] repository_specs
      # @return [void]
      def execute(*repositories)
        begin
          sum = repositories.inject(0) do |sum , repository|
            @repository = repository
            count = Repository.new(repository).info['triple_count']
            puts "#{count} #{repository}"
            sum += count
          end
          puts "#{sum.to_i} total"
        rescue RestClient::ResourceNotFound
          puts "#{@repository} not found"
        rescue RepositoryMisspecified => e
          puts e
        end
      end
    end # Count
  end # Command
end # Dydra
