require 'spec_helper'

RSpec.describe Suricate::Configuration do
  subject { Suricate::Configuration.new(widget_repository: widget_repository,
                                        public_directory: public_directory,
                                        template_repository: template_repository) }
  let(:widget_repository) { double('widget_repository') }
  let(:template_repository) { double('template_repository') }
  let(:public_directory) { '/tmp' }

  describe '#widget_repository' do
    it 'returns the widget repository' do
      expect(subject.widget_repository).to eq(widget_repository)
    end
  end

  describe '#template_repository' do
    it 'returs the template repository' do
      expect(subject.template_repository).to eq(template_repository)
    end
  end

  describe '#public_directory' do
    it 'returns the public directory' do
      expect(subject.public_directory).to eq(public_directory)
    end
  end
end
