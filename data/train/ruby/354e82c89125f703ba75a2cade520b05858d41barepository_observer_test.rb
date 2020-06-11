require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/repository_observer_fixtures"

class RepositoryObserverTest < ActiveSupport::TestCase

  should 'save repository observer' do
    repository_observer_id_from_kalibro = 2
    repository_observer = RepositoryObserverFixtures.repository_observer
    Kalibro::RepositoryObserver.expects(:request).with(:save_repository_observer, 
          {
            :repository_observer => RepositoryObserverFixtures.repository_observer_hash,
            :repository_id => repository_observer.repository_id

          }).returns(:repository_observer_id => repository_observer_id_from_kalibro)
    assert repository_observer.save
    assert_equal repository_observer_id_from_kalibro, repository_observer.id
  end

end
