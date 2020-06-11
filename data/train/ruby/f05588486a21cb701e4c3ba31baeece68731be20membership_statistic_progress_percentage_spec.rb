require 'spec_helper'

describe MembershipStatisticProgressPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      challenge = create(:challenge, chapters_to_read: 'Mar 1 -7')
      challenge.generate_readings
      membership = create(:membership, challenge: challenge)
      challenge.readings[0..3].each do |r|
        create(:membership_reading, membership: membership, reading: r)
      end

      stat = MembershipStatisticProgressPercentage.new(membership: membership)

      expect(stat.calculate).to eq 57
    end
  end


end
