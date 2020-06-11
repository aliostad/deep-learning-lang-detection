require 'docnmock'

module MyModule; end
module AnotherModule; end

describe Docnmock do
  let(:api_url) { 'http://myapi.com' }

  describe '.api' do
    it 'returns the same object for the same url' do
      expect(Docnmock.api(api_url)).to be(Docnmock.api(api_url))
    end

    it 'returns a different object for a different module' do
      expect(Docnmock.api(api_url)).to_not be(Docnmock.api('http://otherapi.com'))
    end

    it 'yields control' do
      expect{ |probe| Docnmock.api(api_url, &probe) }.to yield_control
    end
  end

end
