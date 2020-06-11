require 'minitest_helper'

module DatatablesServer
  describe RepositoryFactory do
    it 'creates the right repository from the data class' do
      module ActiveRecord
        class Relation; end
      end
      class Foo < ActiveRecord::Relation; end

      foo = Foo.new

      repository = RepositoryFactory.create(foo, [], Object.new)

      assert_equal ActiveRecordRepository, repository.class
    end

    it 'raises an error if the repository is not implemented' do
      assert_raises(RepositoryNotImplementedError) do
        repository = RepositoryFactory.create(Object.new, [], Object.new)
      end
    end
  end
end
