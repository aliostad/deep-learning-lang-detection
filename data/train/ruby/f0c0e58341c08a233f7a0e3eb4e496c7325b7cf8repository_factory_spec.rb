require 'spec_helper'

module Orcharding
  describe RepositoryFactory do
    context "create object from hash for a given class" do
      class Test
        extend RepositoryFactory
      end

      let (:repository) { stub }

      it "enables repository injection" do
        Test.repository = repository
        Test.repository.should == repository
      end

      it "uses registered repositories" do
        Test.repository = nil
        lambda { Test.repository }.should raise_error
      end
    end
  end
end
