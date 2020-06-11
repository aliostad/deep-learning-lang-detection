module UseCase
  class GetTransition
    attr_accessor :repository

    def initialize(listener, repository=nil)
      @listener   = listener
      @repository = (repository || Repository::Memory::Transition).new(self)
    end

    def get(id) # or (attributes)?
      @repository.get(id) # or (attributes)?
    end

    def transition_repository_get_success(transition)
      @listener.get_transition_success(transition)
    end

    def transition_repository_get_failure
      @listener.get_transition_failure
    end
  end
end
