require 'spec_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  describe 'admin' do
    let(:user) { User.create!(email: 'test@user.com', password: '12345678', password_confirmation: '12345678', admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { User.create!(email: 'test@user.com', password: '12345678', password_confirmation: '12345678') }

    it_behaves_like 'guest'
    it { should be_able_to :create, Bet }
    it { should be_able_to :manage, :profile }
  end

  describe 'guest' do
    it_behaves_like 'guest'
    it { should_not be_able_to :create, Bet }
  end

  describe 'dynamic permissions' do
    let(:user) { User.create!(email: 'test@user.com', password: '12345678', password_confirmation: '12345678') }
    let(:manage_categories) { Permission.create!(title: 'Permission 1', action: :manage, subject: 'Category') }
    let(:manage_products) { Permission.create!(title: 'Permission 2', action: :manage, subject: 'Product') }

    context 'user has not additonal permissions' do
      it { should_not be_able_to :manage, Category }
      it { should_not be_able_to :manage, Product }
    end

    context 'user has one permission' do
      before do
        user.permissions << manage_categories
      end

      it { should be_able_to :manage, Category }
      it { should_not be_able_to :manage, Product }
    end

    context 'user has several permissions' do
      before do
        user.permissions << manage_categories << manage_products
      end

      it { should be_able_to :manage, Category }
      it { should be_able_to :manage, Product }
    end

    context 'user has permissions only for object' do
      let(:cat1) { Category.create(title: 'Category 1') }
      let(:cat2) { Category.create(title: 'Category 2') }
      before do
        user.permissions << Permission.create!(title: 'Manage cat 1', action: :manage, subject: 'Category', subject_id: cat1.id)
      end

      it { should be_able_to :manage, cat1 }
      it { should_not be_able_to :manage, cat2 }
    end

    context 'custom permissions' do
      let(:custom_permission) { Permission.create!(title: 'Custom', action: :manage, subject: :custom) }
      before do
        user.permissions << custom_permission
      end

      it { should be_able_to :manage, :custom }
    end
  end
end