require 'rails_helper'
require 'processor'

describe Processor::Context do
  describe 'initialize' do
    let(:processing) { FactoryGirl.build(:processing) }
    let(:repository) { FactoryGirl.build(:repository) }
    it 'is expected to set the attributes' do
      context = Processor::Context.new(processing: processing, repository: repository)
      expect(context.repository).to eq(repository)
      expect(context.processing).to eq(processing)
      expect(context.native_metrics).to_not be_nil
    end
  end
end
