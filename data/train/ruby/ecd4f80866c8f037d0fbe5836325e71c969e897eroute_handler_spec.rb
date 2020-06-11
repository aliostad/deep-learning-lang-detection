require File.dirname(__FILE__) + '/../spec_helper'

describe RouteHandler do
  
  before do
    @page = Page.create!(
      :title => 'New Page',
      :slug => 'page',
      :breadcrumb => 'New Page',
      :status_id => '1'
    )
  end
  
  it "should be created" do
    lambda do
      RouteHandler.create!(:url => "(\w+)\/(\w+)\/(\w+)", :fields => 'frequency,name,date', :page => @page)
    end.should change(RouteHandler, :count).by(1)
  end
  
  it "should be validated by presence" do
    route_handler = RouteHandler.new
    route_handler.should_not be_valid
    route_handler.errors.on(:url).should_not be_nil
    route_handler.errors.on(:fields).should_not be_nil
    route_handler.errors.on(:page_id).should_not be_nil
  end
  
  it "should correctly not transform invalid YAML" do
    route_handler = RouteHandler.new(:url => "web", :fields => "web", :derived_parameters => "as: as: 'sadf", :page => @page)
    route_handler.should_not be_valid
    route_handler.errors.on(:derived_parameters).should_not be_nil
  end
  
  it "should correctly not transform string" do
    route_handler = RouteHandler.new(:url => "web", :fields => "web", :derived_parameters => "sadf", :page => @page)
    route_handler.should_not be_valid
    route_handler.errors.on(:derived_parameters).should_not be_nil
  end
  
  it "should correctly not transform blank string" do
    route_handler = RouteHandler.create!(
      :url => '(\w+)\/(\w+)\/(\w+)', 
      :fields => 'frequency,name,date', 
      :page => @page,
      :derived_parameters => ''
    )
    route_handler.should be_valid
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.page.route_handler_params[:frequency].should == 'daily'
    matched_handler.page.route_handler_params[:name].should == 'overview'
    matched_handler.page.route_handler_params[:date].should == 'today'
  end
  
  it "should match path" do
    handler = RouteHandler.create!(:url => '(\w+)\/(\w+)\/(\w+)', :fields => 'frequency,name,date', :page => @page)
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.should == handler
    matched_handler.page.route_handler_params[:frequency].should == 'daily'
    matched_handler.page.route_handler_params[:name].should == 'overview'
    matched_handler.page.route_handler_params[:date].should == 'today'
    RouteHandler.match(%w{some some some}).should == handler
    RouteHandler.match('fengshui/love').should be_nil
  end  
  
  it "should set page from params" do
    another_page = Page.create!(:title => 'Another Page', :slug => 'another-page', 
      :breadcrumb => 'Another Page', :status_id => '1'
    )
    RouteHandler.create!(:url => '(.*)\/(\d+)', :fields => 'page_name,page_number', :page => @page)
    matched_handler = RouteHandler.match('another-page/1')
    matched_handler.page.should == another_page
  end
  
  it "should set derived parameters" do
    handler = RouteHandler.create!(
      :url => '(\w+)\/(\w+)\/(\w+)', 
      :fields => 'frequency,name,date', 
      :page => @page,
      :derived_parameters => derived_parameters
    )
    matched_handler = RouteHandler.match('daily/overview/today')
    matched_handler.page.route_handler_params[:frequency].should == 'daily'
    matched_handler.page.route_handler_params[:name].should == 'overview'
    matched_handler.page.route_handler_params[:date].should == 'today'
    matched_handler.page.route_handler_params[:period].should == 'day'
    matched_handler.page.route_handler_params[:title].should == 'overview'
    matched_handler.page.route_handler_params[:something].should == 'another'
    
    matched_handler = RouteHandler.match('weekly/overview/today')
    matched_handler.page.route_handler_params[:frequency].should == 'weekly'
    matched_handler.page.route_handler_params[:name].should == 'overview'
    matched_handler.page.route_handler_params[:date].should == 'today'
    matched_handler.page.route_handler_params[:period].should == 'other'
    matched_handler.page.route_handler_params[:title].should == 'overview'
    matched_handler.page.route_handler_params[:something].should == 'another'
  end
  
  it "should set special date derived parameters" do
    handler = RouteHandler.create!(:url => '(\w+)', :fields => 'date', :page => @page)
    matched = RouteHandler.match('/20090304')
    matched.page.route_handler_params.should == {
      :date => '20090304',
      :currentdate => '20090304',
      :currentyear => '2009',
      :currentmonth => 'March',
      :currentday => '4',
      :tomorrow => '20090305',
      :yesterday => '20090303',
      :nextweek => '20090309',
      :lastweek => '20090223',
      :nextmonth => '20090401',
      :lastmonth => '20090201',
    }
  end
  
  it "should avoid constant matchers" do
    RouteHandler.create!(:url => 'megapage\/(\w+)', :fields => 'type', :page => @page)
    matched_handler = RouteHandler.match('megapage/sand')
    matched_handler.page.route_handler_params.should == { :type => 'sand' }
  end
  
  it "should select matchers correctly" do
    handler = RouteHandler.create!(:url => 'some\/(\w+)', :fields => 'name', :page => @page)
    RouteHandler.create!(:url => 'megapage\/(\w+)', :fields => 'type', :page => @page)
    matched_handler = RouteHandler.match('some/sand')
    matched_handler.page.route_handler_params.should == { :name => 'sand' }
  end

end