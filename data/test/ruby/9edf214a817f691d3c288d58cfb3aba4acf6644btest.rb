require 'rubygems'
require 'cancan'

class Article; end
class Person; end

module DefaultAbility
  def define_abilities(user)
    can :read, :all
  end
end

class Ability
  include CanCan::Ability
  include DefaultAbility

  def initialize(user)
    define_abilities(user)
  end
end

puts "Default Abilities Defined\n\n"

puts "Can manage articles? " + Ability.new(nil).can?(:manage, Article).to_s
puts "Can read articles? " + Ability.new(nil).can?(:read, Article).to_s
puts "Can manage Person? " + Ability.new(nil).can?(:manage, Person).to_s
puts "Can read Person? " + Ability.new(nil).can?(:read, Person).to_s

module ArticleSuperUserAbility
  def define_abilities(user)
    can :manage, Article
    super
  end
end


puts "Adding ArticleSuperUserAbility..."

Ability.send :include, ArticleSuperUserAbility

puts "Can manage articles? " + Ability.new(nil).can?(:manage, Article).to_s
puts "Can read articles? " + Ability.new(nil).can?(:read, Article).to_s
puts "Can manage Person? " + Ability.new(nil).can?(:manage, Person).to_s
puts "Can read Person? " + Ability.new(nil).can?(:read, Person).to_s
