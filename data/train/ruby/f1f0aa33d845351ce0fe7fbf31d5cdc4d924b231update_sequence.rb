module UseCase
  class UpdateSequence
    attr_accessor :repository

    def initialize(listener, repository=nil)
      @listener   = listener
      @repository = (repository || Repository::Memory::Sequence).new(self)
    end

    def update(id, attributes)
      @repository.update(id, attributes)
    end

    def sequence_repository_update_success(sequence)
      @listener.update_sequence_success(sequence)
    end

    def sequence_repository_update_failure
      @listener.update_sequence_failure
    end
  end
end
