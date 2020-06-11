require 'minitest_helper'

describe 'Locking' do

  let(:repository) { Repository.new :test }
  
  def with_locked(repository, key=:test_process)
    locker = Eternity.locker_for repository.name
    locker.lock key do
      yield
    end
  end

  def assert_locked
    proc { yield }.must_raise Restruct::LockerError
  end

  it 'Commit' do
    repository[:countries].insert 'AR', name: 'Argentina'

    with_locked repository, :commit do
      assert_locked { repository.commit author: 'User', message: 'Commit Message' }
    end

    repository.current_commit.must_be_nil
    repository.changes_count.must_equal 1
  end

  it 'Checkout' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'
    
    repository[:countries].insert 'UY', name: 'Uruguay'
    commit_2 = repository.commit author: 'User', message: 'Commit 2'

    with_locked repository, :checkout do
      assert_locked { repository.checkout commit: commit_1.id }
    end

    repository.current_commit.must_equal commit_2
  end

  it 'Merge' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'
    
    repository[:countries].insert 'UY', name: 'Uruguay'
    commit_2 = repository.commit author: 'User', message: 'Commit 2'

    repository.checkout commit: commit_1.id

    with_locked repository, :merge do
      assert_locked { repository.merge commit: commit_2.id }
    end

    repository.current_commit.must_equal commit_1
  end

  it 'Revert all' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository[:countries].insert 'UY', name: 'Uruguay'
    repository[:cities].insert 'CABA', name: 'Ciudad Autonoma de Buenos Aires'

    with_locked repository, :revert_all do
      assert_locked { repository.revert }
    end

    repository.changes_count.must_equal 3
    repository[:countries].count.must_equal 2
    repository[:cities].count.must_equal 1
  end

  it 'Revert collection' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository[:countries].insert 'UY', name: 'Uruguay'
    repository[:cities].insert 'CABA', name: 'Ciudad Autonoma de Buenos Aires'

    with_locked repository, :revert do
      assert_locked { repository[:countries].revert_all }
    end

    repository.changes_count.must_equal 3
    repository[:countries].count.must_equal 2
    repository[:cities].count.must_equal 1
  end

  it 'Insert' do
    with_locked repository do
      assert_locked { repository[:countries].insert 'AR', name: 'Argentina' }
    end

    repository.changes_count.must_equal 0
  end

  it 'Update' do
    repository[:countries].insert 'AR', name: 'Argentina'
    
    with_locked repository do
      assert_locked { repository[:countries].update 'AR', name: 'Republica Argentina' }
    end

    repository.delta.must_equal 'countries' => {'AR' => {'action' => 'insert', 'data' => {'name' => 'Argentina'}}}
  end

  it 'Delete' do
    repository[:countries].insert 'AR', name: 'Argentina'

    with_locked repository do
      assert_locked { repository[:countries].delete 'AR' }
    end

    repository.delta.must_equal 'countries' => {'AR' => {'action' => 'insert', 'data' => {'name' => 'Argentina'}}}
  end

  it 'Revert' do
    repository[:countries].insert 'AR', name: 'Argentina'

    with_locked repository, :revert do
      assert_locked { repository[:countries].revert 'AR' }
    end

    repository.delta.must_equal 'countries' => {'AR' => {'action' => 'insert', 'data' => {'name' => 'Argentina'}}}
  end

end