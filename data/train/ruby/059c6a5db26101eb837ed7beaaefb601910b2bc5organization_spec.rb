require 'spec_helper'

describe Organization do

  subject { Organization.create(name: "Acme") }

  # public instance methods ...................................................
  it "#current_api_key" do
    subject.api_keys.count.should == 0
    api_key = ApiKey.create!(tokenable_id: subject.id, tokenable_type: "Organization")
    subject.api_keys.count.should == 1
    subject.current_api_key.should == api_key
  end

  it "#regenerate_api_key" do
    3.times { subject.api_keys.create! }
    subject.api_keys.active.count.should == 3
    api_key = subject.regenerate_api_key
    subject.current_api_key.should == api_key
    subject.api_keys.active.count.should == 1
  end

end
