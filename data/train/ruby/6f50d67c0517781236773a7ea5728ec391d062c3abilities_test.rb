require 'test_helper'

class AbilitiesTest < ActiveSupport::TestCase
  test "should only manage spesific groups" do
    user1 = User.create!(username: "Fuu", password: "Fuu")
    user2 = User.create!(username: "Bar", password: "Bar")
    admin = User.create!(username: "Admin", password: "Admin", admin: true)
    group1 = UserGroup.create!
    group2 = UserGroup.create!
    group3 = UserGroup.create!

    group1.managed_groups = [group2, group3]

    group1.users = [user1]
    group2.users = [user2]

    ability1 = Ability.new(user1)
    ability2 = Ability.new(user2)
    ability3 = Ability.new(admin)

    assert ability1.cannot?(:manage, group1)
    assert ability1.can?(:manage, group2)
    assert ability1.can?(:manage, group3)
    assert ability2.cannot?(:manage, group1)
    assert ability2.cannot?(:manage, group2)
    assert ability2.cannot?(:manage, group3)
    assert ability3.can?(:manage, group1)
    assert ability3.can?(:manage, group2)
    assert ability3.can?(:manage, group3)

  end
end
