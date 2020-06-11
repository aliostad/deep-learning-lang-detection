require "spec_helper"

describe Arrthorizer::Rails::ControllerAction do
  describe :key_for do
    context "when the controller lives in a separate namespace" do
      let(:controller_path) { 'namespace/controller_name' }
      let(:controller_path_regex) { %r(#{controller_path}) }
      let(:controller) { double('some_controller', controller_path: controller_path, action_name: 'some_action') }

      specify "that namespace is made part of the key" do
        key = Arrthorizer::Rails::ControllerAction.key_for(controller)

        expect(key).to match(%r(#{controller_path}))
      end
    end
  end
end
