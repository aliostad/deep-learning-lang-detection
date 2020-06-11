require 'minitest_helper'

describe Repository, 'Revert' do

  let(:repository) { Repository.new :test }

  it 'Insert' do
    repository[:countries].insert 'AR', name: 'Argentina'

    reverted_delta = repository.revert

    reverted_delta.must_equal 'countries' => {'AR' => {'action' => 'delete'}}
    repository.wont_be :changes?
  end

  it 'Update' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository.commit author: 'User', message: 'Commit message'

    repository[:countries].update 'AR', name: 'Republica Argentina'

    reverted_delta = repository.revert

    reverted_delta.must_equal 'countries' => {'AR' => {'action' => 'update', 'data' => {'name' => 'Argentina'}}}
    repository.wont_be :changes?
  end

  it 'Delete' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository.commit author: 'User', message: 'Commit message'

    repository[:countries].delete 'AR'

    reverted_delta = repository.revert

    reverted_delta.must_equal 'countries' => {'AR' => {'action' => 'insert', 'data' => {'name' => 'Argentina'}}}
    repository.wont_be :changes?
  end

end