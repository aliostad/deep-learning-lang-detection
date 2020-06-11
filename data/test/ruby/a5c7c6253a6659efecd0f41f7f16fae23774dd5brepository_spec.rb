require 'minitest_helper'

describe Repository do

  let(:repository) { Repository.new :test }

  it 'Initial status' do
    repository.wont_be :changes?
    repository.changes_count.must_equal 0
    repository.wont_be :current_commit?
    repository.current_branch.must_equal 'master'
    repository.branches.must_be_empty
  end

  it 'Empty' do
    repository.must_be_empty

    repository[:countries].insert 'AR', name: 'Argentina'
    repository.commit author: 'User', message: 'Commit message'

    repository.wont_be_empty
  end

  it 'Default branch' do
    Repository.new(:test, default_branch: 'test').current_branch.must_equal 'test'
  end

  it 'Destroy' do
    repository[:countries].insert 'AR', name: 'Argentina'
    repository.commit author: 'User', message: 'Commit message'

    repository.destroy

    repository.must_be_empty
  end

  it 'Replace delta' do
    repository[:countries].insert 'AR', name: 'Argentina'

    repository.delta = {'countries' => {'UY' => {'action' => 'insert', 'data' => {'name' => 'Uruguay'}}}}

    repository.to_h['delta'].must_equal 'countries' => {'UY' => {'action' => 'insert', 'data' => {'name' => 'Uruguay'}}}
  end

  ['To hash', 'Dump'].each do |test|
    it test do
      repository[:countries].insert 'AR', name: 'Argentina'
      repository.commit author: 'User', message: 'Commit message'
      repository[:countries].insert 'UY', name: 'Uruguay'

      repository.to_h.must_equal 'current'  => {'commit' => repository.current_commit.id, 'branch' => 'master'}, 
                                 'branches' => {'master' => repository.current_commit.id}, 
                                 'delta'    => {'countries' => {'UY' => {'action' => 'insert', 'data' => {'name' => 'Uruguay'}}}}
    end
  end

  it 'Restore' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit = repository.commit author: 'User', message: 'Commit message'
    repository[:countries].insert 'UY', name: 'Uruguay'
    
    dump = repository.dump
    repository.destroy

    repository.must_be_empty

    repository.restore dump

    repository.current_commit.must_equal commit
    repository.delta.must_equal 'countries' => {'UY' => {'action' => 'insert', 'data' => {'name' => 'Uruguay'}}}
  end

  it 'In memory instances' do
    Repository.all.must_be_empty

    repository_1 = Repository.new 'repository_1'
    repository_1[:countries].insert 'AR', name: 'Argentina'
    
    repository_2 = Repository.new 'repository_2'
    repository_2[:countries].insert 'UY', name: 'Uruguay'
    
    Repository.all.map(&:name).sort.must_equal %w(repository_1 repository_2)
  end


end