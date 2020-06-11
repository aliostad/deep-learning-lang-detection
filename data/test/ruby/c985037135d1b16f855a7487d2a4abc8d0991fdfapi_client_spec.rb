require 'spec_helper'

describe Tflow::ApiClient do
  it 'should include Authentication from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Authentication
  end
  it 'should include Client from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Client
  end
  it 'should include Dynamic Property from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::DynamicProperties
  end
  it 'should include Job from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Job
  end
  it 'should include Order from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Order
  end
  it 'should include Permission from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Permission
  end
  it 'should include Revision from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Revision
  end
  it 'should include Role from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Role
  end
  it 'should include Tflow Download from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::TflowDownload
  end
  it 'should include Tflow from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Tflow
  end
  it 'should include User from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::User
  end
  it 'should include Workgroup from api_client' do
    Tflow::ApiClient.should include Tflow::ApiClient::Webhook
  end
end
