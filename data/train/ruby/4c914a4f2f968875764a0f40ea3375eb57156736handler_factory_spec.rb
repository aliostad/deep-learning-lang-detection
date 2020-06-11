describe Rute::HandlerFactory do
  it 'should instantiate a static handler for a static route' do
    Rute::Handler::StaticFile.should_receive(:new).with(static_file: 'abc').and_return('static handler')
    Rute::HandlerFactory.build(static_file: 'abc').should == 'static handler'
  end

  it 'should instantiate a code handler for a code route' do
    Rute::Handler::Code.should_receive(:new).with(class: 'blah', method: 'deblah').and_return('code handler')
    Rute::HandlerFactory.build(class: 'blah', method: 'deblah').should == 'code handler'
  end
end