module UseCase
  class UpdateTransition
    attr_accessor :repository

    def initialize(listener, repository=nil)
      @listener   = listener
      @repository = (repository || Repository::Memory::Transition).new(self)
    end

    def update(id, attributes) # or (attributes)?
      @repository.update(id, attributes) # or (attributes)?
    end

    def transition_repository_update_success(transition)
      @listener.update_transition_success(transition)
    end

    def transition_repository_update_failure
      @listener.update_transition_failure
    end
  end
end
