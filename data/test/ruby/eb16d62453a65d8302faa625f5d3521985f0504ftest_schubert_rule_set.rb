require "test/unit"
require "schubert/rule_set"
require "schubert/stub_system"

class TestSchubertRuleSet < Test::Unit::TestCase
  def setup
    @system = Schubert::StubSystem.new
  end

  def test_calculate
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    s = r.calculate

    up = s.up
    down = s.down

    assert_kind_of Schubert::Rules::Package, up[0]
    assert_equal "nginx", up[0].name

    assert_equal [], down
  end

  def test_calculate_against_previous_state_results_nothnig
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    state = r.calculate

    a = Schubert::RuleSet.new @system
    a.package "nginx"
    after = a.calculate(state)

    assert_equal [], after.up
    assert_equal [], after.down
  end

  def test_calculate_against_previous_state_results_in_down
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    state = r.calculate

    a = Schubert::RuleSet.new @system
    after = a.calculate(state)

    assert_equal [], after.up

    down = after.down

    assert_kind_of Schubert::Rules::Package, down[0]
    assert_equal "nginx", down[0].name
  end

  def test_calculate_against_previous_state_results_in_up
    r = Schubert::RuleSet.new @system
    r.package "nginx"

    state = r.calculate

    a = Schubert::RuleSet.new @system
    a.package "nginx"
    a.package "varnish"
    after = a.calculate(state)

    up = after.up

    assert_kind_of Schubert::Rules::Package, up[0]
    assert_equal "varnish", up[0].name

    assert_equal [], after.down
  end
end
