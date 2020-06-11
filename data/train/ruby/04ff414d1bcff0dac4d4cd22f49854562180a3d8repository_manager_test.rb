require './test/test_helper'
require 'repository_manager'

class EntryRepositoryTest < Minitest::Test

  def test_loads_entries
    repository_manager = RepositoryManager.new
    repository_manager.load_entries('event_two_attendees.csv')
    assert_equal 9, repository_manager.entries.length
  end

  def test_find_by
    repository_manager = RepositoryManager.new
    repository_manager.load_entries('event_two_attendees.csv')
    repository_manager.find(:first_name, 'sarah')

    assert_equal 2, repository_manager.queue.length

    assert_equal 'SArah', repository_manager.queue[0].first_name
  end
end
