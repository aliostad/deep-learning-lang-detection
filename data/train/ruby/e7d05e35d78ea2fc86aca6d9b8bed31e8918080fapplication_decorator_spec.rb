require "rails_helper"
require 'sipity/decorators/application_decorator'

module Sipity
  module Decorators
    RSpec.describe ApplicationDecorator do
      let(:object) { double('The Object') }
      let(:repository) { double('The Repository') }

      it 'will have a private repository method' do
        subject = described_class.new(object, repository: repository)
        expect(subject.send(:repository)).to eq(repository)
      end

      it 'will have a QueryRepository as the default repository' do
        subject = described_class.new(object)
        expect(subject.send(:repository)).to be_a(QueryRepository)
      end
    end
  end
end
