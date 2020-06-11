module Predictable
  module Championship

    class RepositoryFactory

      def self.create(aggregate_root_type=nil, contest=nil, user=nil)
        return Repository.new(contest, user) unless aggregate_root_type
        repository = nil

        if aggregate_root_type.to_sym.eql?(:group)
          repository = GroupRepository.new(contest, user)
        elsif aggregate_root_type.to_sym.eql?(:stage)
          repository = StageRepository.new(contest, user)
        end
        repository
      end
    end
  end
end
