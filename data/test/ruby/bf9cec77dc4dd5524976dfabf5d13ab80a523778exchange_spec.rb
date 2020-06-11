require 'exchange'
describe Exchange do
    before :all do
        @exchange = Exchange.new
    end

    it ' dont return exchange ' do
        expect(@exchange.calculate(10, 10)).to eq([])
    end

    it ' should return one bill of $1' do
        expect(@exchange.calculate(9, 10)).to eq([1])
    end

    it ' should return two bills of $1 ' do
        expect(@exchange.calculate(8,10)).to eq([1,1])
    end

    it ' should return one bill of $5 ' do
        expect(@exchange.calculate(5,10)).to eq([5])
    end

    it ' should return one bill of $1 and $5 ' do
        expect(@exchange.calculate(4,10)).to eq([5, 1])
    end


end
