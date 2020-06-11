require_relative "../../test_helper"

module Unit
  module API
    class TestInstance < MiniTest::Test

      class Foo
        include MagnumPI::API::Instance
      end

      describe MagnumPI::API::Instance do
        describe ".initialize" do
          it "defines @api and @resources" do
            api = mock
            api.expects(:finalize).returns(api)
            resources = mock
            resources.expects(:to_hash).returns(resources)

            Foo.expects(:api).returns api
            Foo.expects(:resources).returns resources
            foo = Foo.new

            assert_equal api, foo.instance_variable_get(:@api)
            assert_equal resources, foo.instance_variable_get(:@resources)
          end
        end
        describe "instances" do
          before do
            api = mock
            api.expects(:finalize).returns(api)
            Foo.expects(:api).returns api
            Foo.expects(:resources).returns Hash.new
          end
          describe "#api" do
            it "returns @api" do
              foo, api = Foo.new, api
              foo.instance_variable_set :@api, api
              assert_equal api, foo.api
            end
          end
          describe "#resources" do
            it "returns @resources" do
              foo, resources = Foo.new, resources
              foo.instance_variable_set :@resources, resources
              assert_equal resources, foo.resources
            end
          end
        end
      end

    end
  end
end