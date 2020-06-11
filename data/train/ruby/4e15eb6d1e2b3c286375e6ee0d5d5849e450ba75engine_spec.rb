require 'spec_helper'
require 'fame/defunkt'
require 'fame/engine'

module Fame
  describe Engine do
    it "scores 100, when 1 commit, each scoring 100" do
      coder = { "commits" => 1 }
      rules = <<-EOF
commit = 100
      EOF
      Engine.new(rules).score(coder).must_equal 100
    end

    it "scores 100, when 10 followers, each scoring 10" do
      coder = { "followers" => 10 }
      rules = <<-EOF
follower = 10
      EOF
      Engine.new(rules).score(coder).must_equal 100
    end

    describe "badass" do
      def badass
        {
          "repositories" => [{
            "watchers" => 1000,
            "forks" => 200,
            "name" => "resque"
          }]
        }
      end
      it "scores per watchers and forks" do
        rules = <<-EOF
repository = 1
repository += repository.watchers
repository += 5 * repository.forks
        EOF
        Engine.new(rules).score(badass).must_equal 2001
      end
    end

    describe "defunkt" do
      include Defunkt
      it "scores 1250" do
        rules = <<-EOF
follower = 2
repository = 5
repository = 1 if repository.watchers  < 2 && repository.forks < 2
repository += 10 if repository.watchers  > 10
repository += 10 if repository.forks  >  10
repository = 50 if repository.watchers  > 100 && repository.forks > 100
        EOF
        Engine.new(rules).score(defunkt).must_equal 9568
      end
    end


  end
end
