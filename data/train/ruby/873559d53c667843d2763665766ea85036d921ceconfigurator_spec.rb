# encoding: UTF-8

require 'spec_helper'

include Rosette::Tms

describe SmartlingTms::Configurator do
  let(:configurator) { configurator = SmartlingTms::Configurator.new(nil, nil) }

  describe '#smartling_api' do
    it 'uses the smartling api options from the setter method' do
      configurator.set_api_options(
        smartling_api_key: 'fookey', smartling_project_id: 'fooid'
      )

      configurator.smartling_api.tap do |api|
        expect(api.api.apiKey).to eq('fookey')
        expect(api.api.projectId).to eq('fooid')
      end
    end
  end
end
