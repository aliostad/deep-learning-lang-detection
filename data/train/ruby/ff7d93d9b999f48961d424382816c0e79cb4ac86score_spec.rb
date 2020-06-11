require './spec/helpers'
describe 'score' do

  let(:score) {Score.new}

  it{ score.calculate(dice_set_with([])).should eq(0) }
  it{ score.calculate(dice_set_with([1])).should eq(100) }
  it{ score.calculate(dice_set_with([5])).should eq(50) }
  it{ score.calculate(dice_set_with([1,5])).should eq(150) }
  it{ score.calculate(dice_set_with([2,2,2])).should eq(200) }
  it{ score.calculate(dice_set_with([3,3,3])).should eq(300) }
  it{ score.calculate(dice_set_with([4,4,4])).should eq(400) }
  it{ score.calculate(dice_set_with([5,5,5])).should eq(500) }
  it{ score.calculate(dice_set_with([6,6,6])).should eq(600) }
  it{ score.calculate(dice_set_with([1,1,1])).should eq(1000) }

  it{ score.calculate(dice_set_with([1,1])).should eq(200) }
  it{ score.calculate(dice_set_with([5,5])).should eq(100) }

  it { score.can_calculate?(dice_set_with([2])).should eq(false) }
  it { score.can_calculate?(dice_set_with([2, 2, 2])).should eq(true) }
  it { score.can_calculate?(dice_set_with([2, 2])).should eq(false) }
  it { score.can_calculate?(dice_set_with([1])).should eq(true) }
  it { score.can_calculate?(dice_set_with([5])).should eq(true) }
  it { score.can_calculate?(dice_set_with([4, 4, 4, 4])).should eq(false) }
  it { score.can_calculate?(dice_set_with([4, 4, 4, 4, 4, 4])).should eq(true) }

end
