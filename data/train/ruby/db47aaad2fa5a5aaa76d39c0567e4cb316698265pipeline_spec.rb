require 'rspec'
require 'linepipe'

describe Linepipe do
  describe '.develop' do
    it 'creates a new linepipe process in development mode' do
      process = Linepipe::Process.new
      Linepipe::Process.stub(:new).and_return process

      process.should_receive(:instance_eval)
      process.should_receive(:develop)

      expect(Linepipe.develop {}).to eq(process)
    end
  end

  describe '.run' do
    it 'creates a new linepipe process in run mode' do
      process = Linepipe::Process.new
      Linepipe::Process.stub(:new).and_return process

      process.should_receive(:instance_eval)
      process.should_receive(:run)

      expect(Linepipe.run {}).to eq(process)
    end
  end

  describe '.benchmark' do
    it 'creates a new linepipe process in benchmark mode' do
      process = Linepipe::Process.new
      Linepipe::Process.stub(:new).and_return process

      process.should_receive(:instance_eval)
      process.should_receive(:benchmark).with(2)

      expect(Linepipe.benchmark(2) {}).to eq(process)
    end
  end
end
