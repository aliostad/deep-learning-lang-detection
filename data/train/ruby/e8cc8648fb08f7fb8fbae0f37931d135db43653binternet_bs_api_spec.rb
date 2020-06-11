require 'spec_helper'
require "#{Rails.root}/lib/internet_bs_api.rb"
require "#{Rails.root}/lib/internet_bs_api/domain.rb"

class Api
  include InternetBsApi

  def initialize
  end
end

class DomainApi
  include InternetBsApi::Domain
end

describe InternetBsApi do
  it "should expose domain API calls" do
    api = Api.new
    api.cancel_transfer
    response = api.check_domain("flibberty_gibbet.com")
    response.should_not == nil
  end

  it "should expose bottom level modules directly" do
    api = DomainApi.new
    response = api.check_domain("flibberty_gibbet.com")
    response.should_not == nil
  end
end

