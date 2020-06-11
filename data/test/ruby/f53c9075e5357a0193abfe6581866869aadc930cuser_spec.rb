require 'spec_helper'
require 'cancan/matchers'

describe User do
  it 'says its an admin if its an admin' do
    admin = FactoryGirl.create :admin_user
    expect(admin.admin?).to eq true
  end

  it 'says its not an admin if it isnt an admin' do
    admin = FactoryGirl.create :user
    expect(admin.admin?).to eq false
  end

  describe 'abilities' do
    context 'when I am an admin' do
      before do
        @user = FactoryGirl.create :user, role: 'admin'
      end

      it 'should be able to manage posts' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:post))
      end

      it 'should be able to manage pictures' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:picture))
      end

      it 'should be able to manage addresses' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:address))
      end

      it 'should be able to manage jobs' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:job))
      end

      it 'should be able to manage job_categories' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:job_category))
      end

      it 'should be able to manage packages' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:package))
      end

      it 'should be able to manage projects' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:project))
      end

      it 'should be able to manage project_categories' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:project_category))
      end

      it 'should be able to manage resume_categories' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:resume_category))
      end

      it 'should be able to manage resume_entries' do
        expect(@user).to have_ability(:manage, for: FactoryGirl.create(:resume_entry))
      end
    end

    context 'when I am not an admin' do
      before do
        @user = FactoryGirl.create :user
      end

      it 'should not be able to manage posts' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:post))
      end

      it 'should not be able to manage pictures' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:picture))
      end

      it 'should not be able to manage addresses' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:address))
      end

      it 'should not be able to manage jobs' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:job))
      end

      it 'should not be able to manage job_categories' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:job_category))
      end

      it 'should not be able to manage packages' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:package))
      end

      it 'should not be able to manage projects' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:project))
      end

      it 'should not be able to manage project_categories' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:project_category))
      end

      it 'should not be able to manage resume_categories' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:resume_category))
      end

      it 'should not be able to manage resume_entries' do
        expect(@user).not_to have_ability(:manage, for: FactoryGirl.create(:resume_entry))
      end
    end
  end
end