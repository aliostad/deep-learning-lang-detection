require "rails_helper"

RSpec.describe Ability do
  subject(:ability)    { Ability.new(current_user) }

  context "as an admin" do
    let(:current_user) { build(:admin) }

    it "can manage all videos" do
      expect(subject).to be_able_to(:manage, Video)
    end
  end

  context "as a viewer" do
    let(:current_user) { build(:viewer) }

    it "cannot manage any videos" do
      expect(subject).not_to be_able_to(:manage, Video)
    end
  end

  context "as a guest" do
    let(:current_user) { GuestUser.new }

    it "cannot manage any videos" do
      expect(subject).not_to be_able_to(:manage, Video)
    end
  end
end
