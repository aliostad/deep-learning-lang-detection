require 'spec_helper'

describe Manager do
  include_context "Outback Steakhouse"

  describe "manages?" do
    subject { @rick }

    it { should manage(@outback) }

    it { should manage(@jason) }
    it { should manage(@david) }
    it { should manage(@lisa) }
    it { should manage(@aly) }
    it { should manage(@madison) }

    it { should_not manage(@rick) }
    it { should_not manage(@robin) }

    it { should manage(@ca) }
    it { should manage(@ct) }
    it { should manage(@ny) }
    it { should manage(@nyc) }
    it { should manage(@intl) }
    it { should manage(@brazil) }
    it { should manage(@rio) }

    it { should manage(@coral_springs) }
    it { should manage(@third_ave) }
    it { should manage(@sixth_ave) }

    it_should_behave_like "an associate" do
      let(:manager) { @robin }
    end

    it_should_behave_like "oneself" do
      let(:manager) { @rick }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @jason }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @david }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @lisa }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @aly }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @madison }
    end
  end
end
