require 'minitest_helper'

describe Repository, 'Log' do
  
  let(:repository) { Repository.new :test }

  it 'Without commits' do
    repository.log.must_be_empty
  end

  it 'First commit' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit = repository.commit author: 'User', message: 'First commit'

    repository.log.count.must_equal 1
    repository.log.first.id.must_equal commit.id
  end

  it 'Commit sequence' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'

    repository[:countries].insert 'UY', name: 'Uruguay'
    commit_2 = repository.commit author: 'User', message: 'Commit 2'

    repository.log.count.must_equal 2
    repository.log[0].id.must_equal commit_2.id
    repository.log[1].id.must_equal commit_1.id
  end

  it 'Merge' do
    repository[:countries].insert 'AR', name: 'Argentina'
    commit_1 = repository.commit author: 'User', message: 'Commit 1'
    repository.push
    
    other_repository = Repository.new :other
    other_repository.pull
    
    other_repository[:countries].insert 'UY', name: 'Uruguay'
    commit_2 = other_repository.commit author: 'User', message: 'Commit 2'

    other_repository.push

    repository[:countries].insert 'BR', name: 'Brasil'
    commit_3 = repository.commit author: 'User', message: 'Commit 3'

    repository.pull

    repository.log.count.must_equal 4
    repository.log[0].id.must_equal repository.current_commit.id
    repository.log[1].id.must_equal commit_3.id
    repository.log[2].id.must_equal commit_2.id
    repository.log[3].id.must_equal commit_1.id
  end

end