require 'spec_helper'

describe GrapeRakeTasks::Route do
  describe '.route_with_api_name' do
    let(:route) { grape_route_object }

    it 'adds an API name to a route\'s options hash' do
      altered_route = described_class.route_with_api_name(route, SampleApiOne::API)
      expect(altered_route.options).to have_key(:api)
    end
  end

  describe '.api_routes' do
    let(:api_class) { SampleApiOne::API }

    it 'returns a collection of routes that know their parent API' do
      routes = described_class.api_routes(SampleApiOne::API)
      every_route_has_api = routes.all? { |r| r.options.key?(:api) }
      expect(every_route_has_api).to eq(true)
    end
  end

  describe '.all_routes' do
    it 'returns routes belonging to every subclass' do
      routes = described_class.all_routes(Grape::API)
      api_names = routes.map(&:route_api)
      expect(api_names).to include(SampleApiOne::API)
    end
  end
end
