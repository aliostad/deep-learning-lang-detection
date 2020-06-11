shared_examples_for 'guest' do
  it { should_not be_able_to :manage, :all }
  it { should_not be_able_to :read, :all }
  it { should_not be_able_to :manage, :admin }

  it { should be_able_to :read, Auction }
end

shared_examples_for 'user' do
  it { should be_able_to :create, Bid }
  it { should be_able_to :manage, :profile }
end

shared_examples_for 'manager' do
  it_behaves_like 'user'

  it { should be_able_to :manage, Product }
  it { should be_able_to :manage, Category }
  it { should be_able_to :manage, Auction }
  it { should be_able_to :read, :admin_panel }
end