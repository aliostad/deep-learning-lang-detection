require 'minitest_helper'

describe Repository, 'Push' do

  let(:repository) { Repository.new :test }

  it 'New branch' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit = repository.commit author: 'User', message: 'Commit message'

    Branch.wont_be :exists?, :master

    repository.push

    Branch[:master].id.must_equal commit.id
  end

  it 'Without commit' do
    error = proc { repository.push }.must_raise RuntimeError
    error.message.must_equal "Can't push without commit"
  end

  it 'Fast-forward' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'
    repository.push

    repository[:countries].insert 'UY', name: 'Uruguay'
    commit_2 = repository.commit author: 'User', message: 'Commit 2'
    repository.push

    Branch[:master].id.must_equal commit_2.id
  end

  it 'Rejected' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository.commit author: 'User', message: 'Commit message'

    Branch[:master] = '123456789'

    error = proc { repository.push }.must_raise RuntimeError
    error.message.must_equal 'Push rejected (non fast forward)'
  end

  it 'Forced' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit = repository.commit author: 'User', message: 'Commit message'

    Branch[:master] = '123456789'

    repository.push!

    Branch[:master].id.must_equal commit.id
  end

  it 'Merge' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'
    repository.push
    
    other_repository = Repository.new :other
    other_repository[:countries].insert 'BR', name: 'Brasil'
    commit_2 = other_repository.commit author: 'User', message: 'Commit 2'

    other_repository.pull
    other_repository.push

    Branch[:master].id.must_equal other_repository.current_commit.id
    Branch[:master].parents.must_equal [commit_2, commit_1]
  end

end