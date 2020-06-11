require 'apis'

shared_examples_for 'API' do |api|
  it 'lists products' do
    expect(api.listProducts).to match [
                                          a_hash_including(
                                              name:     an_instance_of(String),
                                              category: an_instance_of(String),
                                              price:    an_instance_of(Float)
                                          )
                                      ]
  end
end

describe WebAPI do
  it 'has a url' do
    api = WebAPI.new 'http://localhost:9292'
    expect(api).to respond_to :url
  end

  it_behaves_like 'API', WebAPI.new('http://localhost:9292')
end

describe FileAPI do
  it 'has a file location' do
    api = FileAPI.new '/etc/myapp/api.db'
    expect(api).to respond_to :location
  end

  it_behaves_like 'API', FileAPI.new('/etc/myapp/api.db')
end
