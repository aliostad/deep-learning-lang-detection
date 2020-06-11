RSpec.describe RecipeMakingService do
  it 'calculation successable rate' do
    expect(RecipeMakingService.calculate_successable_rate(90.0, 90)).to eq 100
    expect(RecipeMakingService.calculate_successable_rate(80.0, 90)).to eq 50
    expect(RecipeMakingService.calculate_successable_rate(70.0, 90)).to eq 25
    expect(RecipeMakingService.calculate_successable_rate(60.0, 90)).to eq 12.5
    expect(RecipeMakingService.calculate_successable_rate(50.0, 90)).to eq 6.25
    expect(RecipeMakingService.calculate_successable_rate(40.0, 90)).to eq 3.125
  end
end

