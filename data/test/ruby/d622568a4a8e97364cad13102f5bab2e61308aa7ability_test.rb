require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
	test 'admin can manage all' do
	  user = users :admin
	  ability = Ability.new user
	  assert ability.can(:manage, CannedComment.new)
	  assert ability.can(:manage, PlayerReport.new)
	  assert ability.can(:manage, Player.new)
	  assert ability.can(:manage, Team.new)
    end

    test 'director can manage all' do
	  user = users :director
	  ability = Ability.new user
	  assert ability.can(:manage, CannedComment.new)
	  assert ability.can(:manage, PlayerReport.new)
	  assert ability.can(:manage, Player.new)
	  assert ability.can(:manage, Team.new)
    end

    test 'coach can manage all' do
	  user = users :coach
	  ability = Ability.new user
	  assert ability.can(:manage, CannedComment.new)
	  assert ability.can(:manage, PlayerReport.new)
	  assert ability.can(:manage, Player.new)
	  assert ability.can(:manage, Team.new)
    end
end