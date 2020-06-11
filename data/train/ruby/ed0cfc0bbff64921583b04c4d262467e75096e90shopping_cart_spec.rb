require 'spec_helper'

describe ShoppingCart do
  let(:discount){ stub(:discount, :calculate => 0, :type => :general) }
  before(:each) do
    subject.add_item FactoryGirl.build(:item, :price => 30)
    subject.add_item FactoryGirl.build(:item, :price => 20)
  end

  it 'should calculate total amount payable' do
    subject.calculate([]).should eql 50
  end

  it 'should deduct discount when applicable' do
    discount.should_receive(:applicable?).with(subject).and_return(true)
    discount.should_receive(:calculate).with(subject)
    subject.calculate([discount])
  end

  it 'should not deduct discount when not applicable' do
    discount.should_receive(:applicable?).with(subject).and_return(false)
    discount.should_not_receive(:calculate)

    subject.calculate([discount])
  end

  it 'should deduct any applicable discounts from total payable' do
    discount.stub(:applicable? => true)
    discount.should_receive(:calculate).with(subject).and_return(30)

    subject.calculate([discount]).should eql 20
  end

  let(:percentage_discount1){ stub(:percentage_discount1, :calculate => 0, :type => :percentage, :applicable? => true) }
  let(:percentage_discount2){ stub(:percentage_discount2, :calculate => 0, :type => :percentage, :applicable? => true) }
  let(:price_discount){ stub(:price_discount, :calculate => 0, :type => :price, :applicable? => true) }

  it 'should only apply a percentage disount once' do
    price_discount.should_receive(:calculate)
    percentage_discount1.should_receive(:calculate).with(subject).and_return(30)
    percentage_discount2.should_not_receive(:calculate)

    subject.calculate([price_discount, percentage_discount1, percentage_discount2])
  end
end
