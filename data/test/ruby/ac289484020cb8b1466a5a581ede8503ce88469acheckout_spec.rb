require 'minitest_helper'

describe Repository, 'Checkout' do

  let(:repository) { Repository.new :test }

  describe 'Branch' do

    it 'Local' do
      repository[:countries].insert 'AR', name: 'Argentina'
      commit_1 = repository.commit author: 'User', message: 'Commit 1'

      repository.branch :test_branch

      repository[:countries].insert 'UY', name: 'Uruguay'
      commit_2 = repository.commit author: 'User', message: 'Commit 2'

      repository.current_branch.must_equal 'master'
      repository.current_commit.must_equal commit_2

      delta = repository.checkout branch: :test_branch

      delta.must_equal 'countries' => {'UY' => {'action' => 'delete'}}

      repository.current_branch.must_equal 'test_branch'
      repository.current_commit.must_equal commit_1

      repository.branches.to_h.must_equal 'master' => commit_2.id, 
                                       'test_branch' => commit_1.id
    end

    it 'Remote' do
      other_repository = Repository.new :other
      other_repository[:countries].insert 'AR', name: 'Argentina'
      commit = other_repository.commit author: 'User', message: 'Commit message'
      
      Branch[:test_branch] = commit.id

      delta = repository.checkout branch: :test_branch

      delta.must_equal 'countries' => {'AR' => {'action' => 'insert', 'data' => {'name' => 'Argentina'}}}

      repository.current_branch.must_equal 'test_branch'
      repository.current_commit.must_equal commit
      repository.branches.to_h.must_equal 'test_branch' => commit.id
    end

    it 'Invalid' do
      error = proc { repository.checkout branch: :test_branch }.must_raise RuntimeError
      error.message.must_equal 'Invalid branch test_branch'
    end

  end

  describe 'Commit' do

    it 'Valid' do
      repository[:countries].insert 'AR', name: 'Argentina'
      commit_1 = repository.commit author: 'User', message: 'Commit 1'

      repository[:countries].insert 'UY', name: 'Uruguay'
      commit_2 = repository.commit author: 'User', message: 'Commit 2'

      repository.current_branch.must_equal 'master'
      repository.current_commit.must_equal commit_2
      repository.branches.to_h.must_equal 'master' => commit_2.id

      delta = repository.checkout commit: commit_1.id

      delta.must_equal 'countries' => {'UY' => {'action' => 'delete'}}

      repository.current_branch.must_equal 'master'
      repository.current_commit.must_equal commit_1
      repository.branches.to_h.must_equal 'master' => commit_1.id
    end

    it 'Invalid' do
      error = proc { repository.checkout commit: '123456789' }.must_raise RuntimeError
      error.message.must_equal 'Invalid commit 123456789'
    end

    it 'Null' do
      repository[:countries].insert 'AR', name: 'Argentina'
      commit_1 = repository.commit author: 'User', message: 'Commit 1'

      repository[:countries].insert 'UY', name: 'Uruguay'
      commit_2 = repository.commit author: 'User', message: 'Commit 2'

      delta = repository.checkout commit: nil

      delta.must_equal 'countries' => {
        'AR' => {'action' => 'delete'},
        'UY' => {'action' => 'delete'}
      }

      repository.current_branch.must_equal 'master'
      repository.current_commit.must_be_nil
      repository.branches.to_h.must_be_empty
    end

  end

  it 'With uncommitted changes' do
    repository[:countries].insert 'AR', name: 'Argentina'

    error = proc { repository.checkout branch: :test_branch }.must_raise RuntimeError
    error.message.must_equal "Can't checkout with uncommitted changes"
  end

end