require_relative "../lib/zellers"

RSpec.describe ZellersCoungruence do
  context ".calculate" do
    it "returns 'Friday' for '2, 1, 1991'" do
      day = ZellersCoungruence.calculate(2, 1, 1991)
      day.should == 'Friday'
    end

    it "returns 'Monday' for '7, 21, 2014'" do
      day = ZellersCoungruence.calculate(7, 21, 2014)
      day.should == 'Monday'
    end

    it "returns 'Tuesday' fpr '2, 29, 2000" do
      day = ZellersCoungruence.calculate(2, 29, 2000)
      day.should == 'Tuesday'
    end
  end

end