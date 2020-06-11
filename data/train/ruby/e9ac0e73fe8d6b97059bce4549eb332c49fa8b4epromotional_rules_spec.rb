require 'promotional_rules'

describe Promotional_Rules do

  context 'Running promotions' do

    let(:promotional_rules) { Promotional_Rules.new }
    let(:order_1) { {'001' => {:Name => 'Lavender heart', :Price => 9.25, :Quantity => 1} } }
    let(:order_2) { {'001' => {:Name => 'Lavender heart', :Price => 9.25, :Quantity => 8} } }
    let(:order_3) { {'003' => {:Name => 'Personalised cufflinks', :Price => 45.00, :Quantity => 2} } }

    it 'Calculate a percentage of a total' do
      expect(promotional_rules.calculate_percentage 115.50, 10).to eq 11.55
    end

    it 'Calculate 10% discount of purchase (no discount due)' do
      expect(promotional_rules.per_cent_discount 9.25).to eq 0.00
    end

    it 'Calculate 10% discount of purchase (discount due)' do
      expect(promotional_rules.per_cent_discount 115.50).to eq 11.55
    end

    it 'Calculate Lavender heart discount (no discount due)' do
      expect(promotional_rules.lavender_heart_discount order_1).to eq 0.00
    end

    it 'Calculate Lavender heart discount (discount due)' do
      expect(promotional_rules.lavender_heart_discount order_2).to eq 6.00
    end

    it 'Calculate total discount due for purchase (no discount due)' do
      expect(promotional_rules.calculate_discount order_1, 9.25).to eq 0.00
    end

    it 'Calculate total discount due for purchase (Lavender heart discount only)' do
      expect(promotional_rules.calculate_discount order_2, 27.75).to eq 6.00
    end

    it 'Calculate total discount due for purchase (10% discount only)' do
      expect(promotional_rules.calculate_discount order_3, 90.00).to eq 9.00
    end

    it 'Calculate total discount due for purchase (both discounts)' do
      expect(promotional_rules.calculate_discount order_2, 74.00).to eq 12.80
    end

  end

end