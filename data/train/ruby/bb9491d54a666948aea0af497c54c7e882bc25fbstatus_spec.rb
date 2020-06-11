require 'spec_helper'

describe Aragog::Handler::Status do

  context "#handle" do

    it "passes for status codes of 200" do
      request = build_request :response => build_response(:status => 200)
      handler = Aragog::Handler::Status.new request
      handler.handle

      handler.should be_passed
    end

    it "passes for status codes of 201" do
      request = build_request :response => build_response(:status => 201)
      handler = Aragog::Handler::Status.new request
      handler.handle

      handler.should be_passed
    end

    it "passes for status codes of 401" do
      request = build_request :response => build_response(:status => 401)
      handler = Aragog::Handler::Status.new request
      handler.handle

      handler.should be_passed
    end

    it "fails for status codes of 404" do
      request = build_request :response => build_response(:status => 404)
      handler = Aragog::Handler::Status.new request
      handler.handle

      handler.should be_failed
    end

    it "fails for status codes of 500" do
      request = build_request :response => build_response(:status => 500)
      handler = Aragog::Handler::Status.new request
      handler.handle

      handler.should be_failed
    end

  end

end
