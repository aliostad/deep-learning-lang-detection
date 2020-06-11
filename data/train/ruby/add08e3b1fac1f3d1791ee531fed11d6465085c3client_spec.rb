require 'shipping_api'

describe ShippingAPI::Client do
  describe '#initialize' do
    let(:api_url) { 'http://web.service.com/api' }
    let(:api_key) { '238h4regnudfjls' }

    it 'provides access to config' do
      c = ShippingAPI::Client.new(api_url, api_key)
      expect(c.config).to be_a ShippingAPI::Client::Configuration
      expect(c.config.api_url).to eq api_url
      expect(c.config.api_key).to eq api_key
    end

    it 'prevents changing config once client has been inited' do
      c = ShippingAPI::Client.new(api_url, 'something')
      expect do
        c.config.api_key = 'else'
      end.to raise_error(NoMethodError)
    end
  end
end
