require 'spec_helper'
require "cancan/matchers"

describe AdminAbility do
  subject { ability }

  wallet=Factory :wallet

  context "Admin manage all" do

  #wallet_with_much_money=Factory :wallet_with_much_money
    admin=wallet.user
    admin.admin=true
    admin.save
    #AdminAbility.new(admin) it's the Ability sub class's name your custom
    let(:ability){ AdminAbility.new(admin) }
    it { should be_able_to(:manage, :all) }

    it { should be_able_to(:manage, Product) }
    it { should be_able_to(:manage, Category) }
    it { should be_able_to(:manage, Comment) }
    it { should be_able_to(:manage, Wallet) }
    it { should be_able_to(:manage, Tradeinfo) }
    it { should be_able_to(:manage, Chinabank) }
    it { should be_able_to(:manage, Moneyrecode) }
    it { should be_able_to(:manage, UndoItem) }
  end

end
