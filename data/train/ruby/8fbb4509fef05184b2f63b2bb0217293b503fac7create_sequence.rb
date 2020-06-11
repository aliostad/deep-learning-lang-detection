module UseCase
  class CreateSequence
    attr_accessor :repository

    def initialize(listener, repository=nil)
      @listener   = listener
      @repository = (repository || Repository::Memory::Sequence).new(self)
    end

    def create(attributes)
      @repository.create(attributes)
    end

    def sequence_repository_create_success(sequence)
      @listener.create_sequence_success(sequence)
    end

    def sequence_repository_create_failure
      @listener.create_sequence_failure
    end
  end
end
