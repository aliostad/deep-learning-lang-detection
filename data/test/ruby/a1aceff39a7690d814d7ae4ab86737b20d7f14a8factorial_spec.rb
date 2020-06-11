require_relative('factorial')

describe 'factorial_iterative_one' do
  context "calc factorial" do
    it 'should calculate a factorial' do
      expect(factorial_iterative_one(5)).to eq(5 * 4 * 3 * 2 * 1)
    end
    it 'should calculate another factorial' do
      expect(factorial_iterative_one(6)).to eq(6 * 5 * 4 * 3 * 2 * 1)
    end
  end
end

describe 'factorial_recursive_one' do
  context "calc factorial" do
    it 'should calculate a factorial' do
      expect(factorial_recursive_one(5)).to eq(5 * 4 * 3 * 2 * 1)
    end
    it 'should calculate another factorial' do
      expect(factorial_recursive_one(6)).to eq(6 * 5 * 4 * 3 * 2 * 1)
    end
  end
end

describe 'factorial_iterative_two' do
  context "calc factorial" do
    it 'should calculate a factorial' do
      expect(factorial_iterative_two(5)).to eq(5 * 4 * 3 * 2 * 1)
    end
    it 'should calculate another factorial' do
      expect(factorial_iterative_two(6)).to eq(6 * 5 * 4 * 3 * 2 * 1)
    end
  end
end

describe 'factorial_recursive_two' do
  context "calc factorial" do
    it 'should calculate a factorial' do
      expect(factorial_recursive_two(5)).to eq(5 * 4 * 3 * 2 * 1)
    end
    it 'should calculate another factorial' do
      expect(factorial_recursive_two(6)).to eq(6 * 5 * 4 * 3 * 2 * 1)
    end
  end
end