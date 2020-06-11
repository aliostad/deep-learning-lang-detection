describe KashflowApi::Api do
  let(:config) do
    KashflowApi.blank
    
    KashflowApi.configure do |c|
      c.username = "foo"
      c.password = "bar"
      c.loggers = false
    end
  end
  
  it "should require configuring" do
    KashflowApi.blank
    
    KashflowApi.api.should be_nil
  end
  
  it "should have a methods list" do
    config
    
    KashflowApi.api_methods.should be_a Array
    KashflowApi::Api.methods.should be_a Array
    KashflowApi::Api.methods.length.should >= 10
  end
  
  it "should define the methods on itself" do
    a_method = KashflowApi.api_methods[10]
    
    KashflowApi::Api.new().methods.include?(a_method).should be_true
  end
end