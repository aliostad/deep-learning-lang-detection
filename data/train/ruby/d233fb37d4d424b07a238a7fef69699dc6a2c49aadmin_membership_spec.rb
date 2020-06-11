require 'rails_helper'

RSpec.describe AdminMembership, :type => :model do
  context '#can_manage?' do
    it 'cannot manage self' do
      expect(subject.can_manage?(subject)).to be_falsey
    end

    it 'cannot manage another memberships from another account' do
      account = Account.new
      another_account = Account.new
      ms1 = AdminMembership.new(account: account)
      ms2 = AdminMembership.new(account: account)
      ms3 = AdminMembership.new(account: another_account)

      expect(ms1.can_manage?(ms3)).to be_falsey
      expect(ms1.can_manage?(ms2)).to be_truthy
    end

    it 'can manage admins' do
      regular = RegularMembership.new
      admin = AdminMembership.new
      owner = OwnerMembership.new

      expect(subject.can_manage?(regular)).to be_truthy
      expect(subject.can_manage?(admin)).to be_truthy
      expect(subject.can_manage?(owner)).to be_falsey
    end
  end

  context '#managable_by_admin?' do
    it { should be_managable_by_admin }
  end
end
