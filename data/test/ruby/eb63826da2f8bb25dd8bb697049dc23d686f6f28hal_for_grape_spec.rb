require 'spec_helper'

module IntegrationTests

  class FooApi < ::Grape::API
    desc 'foo api description', rel: 'foo api'
    get '/foo_path/'
  end

  class SubApi < ::Grape::API
    desc 'bar api description with {param}', rel: 'bar api'
    get 'bar_path/:param'

    desc 'qux api description', rel: 'qux api'
    get 'qux_path'
  end

  class BazApi < ::Grape::API

    include Grape::Hal

    mount FooApi
    mount SubApi

    hal_for '/' do
      hal_for '/sub', rel: 'sub', title: 'a sub api module' do
        mount SubApi
      end
      mount FooApi
    end

  end

  describe 'Hal for grape' do

    include Rack::Test::Methods

    def app
      Rack::Builder.new do
        run BazApi
      end
    end

    describe 'root path' do

      subject {
        response = get '/', :format => 'json'
        JSON.parse(response.body)['_links']
      }

      it { should == {
          'self' => {
              'href' => '/'
          },
          'sub' => {
              'href' => '/sub',
              'title' => 'a sub api module'
          },
          'foo api' => {
              'href' => '/foo_path',
              'title' => 'foo api description'
          }
      }}

    end


  end
end