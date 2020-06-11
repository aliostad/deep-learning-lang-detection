require "cancan/matchers"

describe "abilities" do
  subject { ability }
  let(:ability) { Ability.new(member) }
  let(:member) { nil }

  context "when member is a content admin" do
    let(:member){ Member.find_by_role(Member::ROLE_CONTENT_ADMIN) }

    it { should be_able_to(:manage, IdeaAction.new) }
    it { should be_able_to(:manage, Event.new) }
    it { should be_able_to(:manage, Idea.new) }
    it { should be_able_to(:manage, Talk.new) }
    it { should be_able_to(:manage, member) }
    it { should_not be_able_to(:manage, Member.new) }
    it { should be_able_to(:manage, Interaction) }
  end

  context "when member is a global admin" do
    let(:member){ Member.find_by_role(Member::ROLE_GLOBAL_ADMIN) }

    it { should be_able_to(:manage, IdeaAction.new) }
    it { should be_able_to(:manage, Event.new) }
    it { should be_able_to(:manage, Idea.new) }
    it { should be_able_to(:manage, Talk.new) }
    it { should be_able_to(:manage, Member.new) }
    it { should be_able_to(:manage, Interaction) }
  end

  context "when member is a regular member" do
    let(:member){ Member.find_by_role(Member::ROLE_REGULAR) }

    it { should be_able_to(:ideas, Event.new) }
    it { should_not be_able_to(:manage, Event.new) }

    it { should be_able_to(:random, IdeaAction.new) }
    it { should be_able_to(:recent, IdeaAction) }
    it { should be_able_to(:create, IdeaAction) }
    it { should be_able_to(:react, IdeaAction) }
    it { should_not be_able_to(:manage, IdeaAction) }

    it { should be_able_to(:random, Idea.new) }
    it { should be_able_to(:create, Idea.new) }
    it { should be_able_to(:show_idea_url, Idea.new) }
    it { should_not be_able_to(:manage, Idea.new) }

    it { should_not be_able_to(:manage, Talk.new) }

    it { should be_able_to(:manage, member) }
    it { should_not be_able_to(:manage, Member.new) }

    it { should be_able_to(:create, Interaction.new) }
    it { should be_able_to(:update, Interaction) }
  end
end