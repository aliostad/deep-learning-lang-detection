require 'spec_helper'

describe Tree do
  let(:instance) {Tree.new()}

  describe 'calculate method should give correct result' do
    it '[one] N:3 A:3 D:2 result:3 ' do
      instance.setup_value(weight: 3,volume: 3,proviso: 2)
      expect(instance.calculate).to eq(3)
    end

    it '[two] N:3 A:3 D:3 result:1' do
      instance.setup_value(weight: 3,volume: 3,proviso: 3)
      expect(instance.calculate).to eq(1)
    end

    it '[three] N:4 A:3 D:2 result:6' do
      instance.setup_value(weight: 4,volume: 3,proviso: 2)
      expect(instance.calculate).to eq(6)
    end

    it '[four]  N:4 A:5 D:2 result:7' do
      instance.setup_value(weight: 4,volume: 5,proviso: 2)
      expect(instance.calculate).to eq(7)
    end

  end


end