# encoding: UTF-8

require 'spec_helper'

include Rosette::Tms::SmartlingTms

describe SmartlingApi do
  let(:smartling_api) { SmartlingApi }

  it 'responds to all smartling file api methods' do
    api = smartling_api.new
    expect(api).to respond_to(:list)
    expect(api).to respond_to(:status)
    expect(api).to respond_to(:download)
    expect(api).to respond_to(:upload)
    expect(api).to respond_to(:rename)
    expect(api).to respond_to(:delete)
  end

  describe '#use_sandbox?' do
    it 'returns true/false depending on the options passed' do
      expect(smartling_api.new(use_sandbox: false).use_sandbox?).to be(false)
      expect(smartling_api.new(use_sandbox: true).use_sandbox?).to be(true)
    end
  end

  describe '#preapprove_translations?' do
    it 'returns true/false depending on the options passed' do
      expect(smartling_api.new(preapprove_translations: false).preapprove_translations?).to be(false)
      expect(smartling_api.new(preapprove_translations: true).preapprove_translations?).to be(true)
    end
  end

  describe '#api' do
    it 'returns a sandbox api when asked' do
      api = smartling_api.new(use_sandbox: true)
      expect(api.use_sandbox).to be(true)
    end

    it 'does not return return a sandbox api when asked' do
      api = smartling_api.new(use_sandbox: false)
      expect(api.use_sandbox).to be(false)
    end

    it 'uses the api credentials from the initial config' do
      api = smartling_api.new({
        smartling_api_key: '12345-abcde', smartling_project_id: 'abc'
      })

      expect(api.api.apiKey).to eq('12345-abcde')
      expect(api.api.projectId).to eq('abc')
    end
  end
end
