require 'rails_helper'

RSpec.describe OwnerMembership, :type => :model do
  context '#can_manage?' do
    it 'cannot manage self' do
      expect(subject.can_manage?(subject)).to be_falsey
    end

    it 'cannot manage another memberships from another account' do
      account = Account.new
      another_account = Account.new
      ms1 = described_class.new(account: account)
      ms2 = described_class.new(account: account)
      ms3 = described_class.new(account: another_account)

      expect(ms1.can_manage?(ms3)).to be_falsey
      expect(ms1.can_manage?(ms2)).to be_truthy
    end

    it 'can manage anyone' do
      regular = RegularMembership.new
      admin = AdminMembership.new

      expect(subject.can_manage?(regular)).to be_truthy
      expect(subject.can_manage?(admin)).to be_truthy
    end
  end

  context '#managable_by_admin?' do
    it { should_not be_managable_by_admin }
  end
end