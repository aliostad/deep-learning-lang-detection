require "spec_helper"

describe Arpad::Calculator do
  describe "#calcualte_elo" do
    context "with a default k factor" do
      context "if the player wins" do
        it { expect(calculate_elo(1400, 1400, "win")).to be 1408 }
        it { expect(calculate_elo(1400, 1500, "win")).to be 1410 }
        it { expect(calculate_elo(1800, 1300, "win")).to be 1800 }
        it { expect(calculate_elo(1300, 1800, "win")).to be 1315 }
      end
      context "if the player loses" do
        it { expect(calculate_elo(1400, 1400, "lose")).to be 1392 }
        it { expect(calculate_elo(1400, 1500, "lose")).to be 1394 }
        it { expect(calculate_elo(1800, 1300, "lose")).to be 1784 }
        it { expect(calculate_elo(1300, 1800, "lose")).to be 1299 }
      end
      context "if the player ties" do
        it { expect(calculate_elo(1400, 1400, "tie")).to be 1400 }
        it { expect(calculate_elo(1400, 1500, "tie")).to be 1402 }
        it { expect(calculate_elo(1800, 1300, "tie")).to be 1792 }
        it { expect(calculate_elo(1300, 1800, "tie")).to be 1307 }
      end
    end

    context "win a k factor of 32" do
      context "if the player wins" do
        it { expect(calculate_elo(1400, 1400, "win", k_factor: 32)).to be 1416 }
        it { expect(calculate_elo(1800, 1300, "win", k_factor: 32)).to be 1801 }
        it { expect(calculate_elo(1400, 1500, "win", k_factor: 32)).to be 1420 }
        it { expect(calculate_elo(1300, 1800, "win", k_factor: 32)).to be 1330 }
      end
      context "if the player loses" do
        it { expect(calculate_elo(1400, 1400, "lose", k_factor: 32)).to be 1384 }
        it { expect(calculate_elo(1400, 1500, "lose", k_factor: 32)).to be 1388 }
        it { expect(calculate_elo(1800, 1300, "lose", k_factor: 32)).to be 1769 }
        it { expect(calculate_elo(1300, 1800, "lose", k_factor: 32)).to be 1298 }
      end
      context "if the player ties" do
        it { expect(calculate_elo(1400, 1400, "tie", k_factor: 32)).to be 1400 }
        it { expect(calculate_elo(1400, 1500, "tie", k_factor: 32)).to be 1404 }
        it { expect(calculate_elo(1800, 1300, "tie", k_factor: 32)).to be 1785 }
        it { expect(calculate_elo(1300, 1800, "tie", k_factor: 32)).to be 1314 }
      end
    end

    context "with an invalid outcome value" do
      it { expect{calculate_elo(1300, 1800, "foo")}.to raise_error "user inputted foo which is not a valid outcome" }
      it { expect(calculate_elo(1300, 1800, :win)).to be 1315 }
      it { expect(calculate_elo(1300, 1800, :lose)).to be 1299 }
      it { expect(calculate_elo(1300, 1800, :tie)).to be 1307 }
    end

    context "if the elo input is non-integer" do
      it "should try to force integer" do
        expect(calculate_elo("1300", "1800", "win")).to be 1315
      end
    end
  end

  def calculate_elo(elo_one, elo_two, outcome, config = {})
    Arpad::Calculator.calculate_elo(elo_one, elo_two, outcome, config)
  end
end
