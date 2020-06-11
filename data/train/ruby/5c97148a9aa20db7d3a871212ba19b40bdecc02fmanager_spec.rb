require 'spec_helper'

describe Manager do
  include_context "Outback Steakhouse"

  describe "manages?" do
    subject { @jason }

    it { should_not manage(@outback) }

    it { should manage(@madison) }

    it { should_not manage(@rick) }
    it { should_not manage(@robin) }
    it { should_not manage(@jason) }
    it { should_not manage(@david) }
    it { should_not manage(@lisa) }
    it { should_not manage(@aly) }

    it { should manage(@ny) }
    it { should manage(@nyc) }

    it { should_not manage(@ca) }
    it { should_not manage(@ct) }
    it { should_not manage(@intl) }
    it { should_not manage(@brazil) }
    it { should_not manage(@rio) }

    it { should manage(@third_ave) }
    it { should manage(@sixth_ave) }

    it { should_not manage(@coral_springs) }

    it_should_behave_like "a subordinate" do
      let(:manager) { @rick }
    end

    it_should_behave_like "a subordinate" do
      let(:manager) { @robin }
    end

    it_should_behave_like "oneself" do
      let(:manager) { @jason }
    end

    it_should_behave_like "an associate" do
      let(:manager) { @david }
    end

    it_should_behave_like "an associate" do
      let(:manager) { @lisa }
    end

    it_should_behave_like "an associate" do
      let(:manager) { @aly }
    end

    it_should_behave_like "a boss" do
      let(:manager) { @madison }
    end
  end
end
