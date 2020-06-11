module UseCase
  class ListTransitionsFor
    attr_accessor :repository

    def initialize(listener, repository=nil)
      @listener   = listener
      @repository = repository.new(self) || Repository::Memory::Transition.new(self)

    end

    def list(position)
      @repository.list(position)
    end

    def transition_repository_list_success(transitions)
      @listener.list_transitions_for_success(transitions)
    end

    def transition_repository_list_failure
      @listener.list_transitions_for_failure
    end
  end
end
