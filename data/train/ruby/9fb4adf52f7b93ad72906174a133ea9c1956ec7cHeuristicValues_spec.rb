require_relative '../bins/HeuristicValues.rb'

describe HeuristicValues do 
  before do
    @heuristic = HeuristicValues.new
  end

  it 'calculates this string' do
    expect(@heuristic.get_line_score("OOXEEE", 'X')).to eq 2
  end

  it 'calculate this string' do
    expect(@heuristic.get_line_score("EXXXO", 'X')).to eq 500
  end

  context 'check X player scores' do
    before do
      @list_of_combos = %w(XOEEE XXEEE XOXEEE OOOEE OXEEE XXEEE OOEEE OEEEE XXXEEE XOOEE XOEEE OXEE OXEEE XXOEEE OOXEE OOEEE OEEEE XOEEE)  
    end

    it '::calculate_score for the whole list_of_combos with last move = X' do
      expect(@heuristic.calculate_score(@list_of_combos, 'X')).to eq 526
    end

    it '::calculate_score for the whole list_of_combos with last move = O' do 
      expect(@heuristic.calculate_score(@list_of_combos, 'O')).to eq 542
    end

    it '::calculate_score for the list_of_combos plus one winning line' do
      @list_of_combos << "EXXXXE"
      expect(@heuristic.calculate_score(@list_of_combos, 'X')).to eq 100526
    end
  end

end