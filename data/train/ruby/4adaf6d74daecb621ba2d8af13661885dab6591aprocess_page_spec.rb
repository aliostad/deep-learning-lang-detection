require_relative 'spec_helper'

describe 'ProcessPage' do
  
  it 'should implement a process page interface' do
    lambda{Watirmark::ProcessPage.new('pp')}.should_not raise_error
  end
  
  it 'should support an activate method' do
    p = Watirmark::ProcessPage.new('pp')
    lambda{p.activate}.should_not raise_error
  end
  
end

describe 'Process Page Views' do
  
  before :all do
    class ProcessPageTest < Watirmark::Page
      keyword(:a) {'a'}
      process_page('ProcessPage 1') do
        keyword(:b) {'b'}
      end
      process_page('ProcessPage 2') do
        keyword(:c) {'c'}
        keyword(:d) {'d'}
      end
      keyword(:e) {'e'}
    end

    class NestedProcessPageTest < Watirmark::Page
      keyword(:a) {'a'}
      process_page('ProcessPage 1') do
        keyword(:b) {'b'}
        process_page('ProcessPage 1.1') do
          keyword(:b1) {'b1'}
          keyword(:b2) {'b2'}
          process_page('ProcessPage 1.1.1') do
            keyword(:b3) {'b3'}
          end
        end
      end
      keyword(:c) {'c'}
    end

    class DefaultView < Watirmark::Page
      keyword(:a) {'a'}
      keyword(:b) {'b'}
    end

    class ProcessPageView < Watirmark::Page
      process_page 'page 1' do
        keyword(:a) {'a'}
      end
      process_page 'page 2' do
        keyword(:b) {'b'}
      end
    end

    class ProcessPageAliasView < Watirmark::Page
      process_page 'page 1' do
        process_page_alias 'page a'
        process_page_alias 'page b'
        keyword(:a) {'a'}
      end
      process_page 'page 2' do
        keyword(:b) {'b'}
      end
    end

    class ProcessPageSubclassView < ProcessPageView
      process_page 'page 3' do
        keyword(:c) {'c'}
      end
    end

    class ProcessPageCustomNav < Watirmark::Page
      process_page_navigate_method Proc.new {}
      process_page_submit_method Proc.new {}
      process_page_active_page_method Proc.new {}
      process_page 'page 4' do
        keyword(:d) {'d'}
      end
    end

    @processpagetest = ProcessPageTest.new
    @nestedprocesspagetest = NestedProcessPageTest.new
    @processpage = ProcessPageView.new
    @processpagealias = ProcessPageAliasView.new
    @processpagesubclass = ProcessPageSubclassView.new
    @processpagecustomnav = ProcessPageCustomNav.new
  end
 
  it 'should only activate process_page when in the closure' do
    @processpagetest.a.should == 'a'
    @processpagetest.b.should == 'b'
    @processpagetest.c.should == 'c'
    @processpagetest.d.should == 'd'
    @processpagetest.e.should == 'e'
    @processpagetest.keywords.should == [:a,:b,:c,:d,:e]
  end
  
  it 'should show all keywords for a given process page' do
    @processpagetest.process_page('ProcessPage 1').keywords.should == [:b]
    @processpagetest.process_page('ProcessPage 2').keywords.should == [:c, :d]
  end
  
  it 'should activate the nested process_page where appropriate' do
    @nestedprocesspagetest.a.should == 'a'
    @nestedprocesspagetest.b.should == 'b'
    @nestedprocesspagetest.b1.should == 'b1'
    @nestedprocesspagetest.b2.should == 'b2'
    @nestedprocesspagetest.b3.should == 'b3'
    @nestedprocesspagetest.c.should == 'c'
  end
  
  it 'should support defining the process page navigate method' do
    custom_method_called = false
    Watirmark::ProcessPage.navigate_method_default = Proc.new { custom_method_called = true }
    @processpagetest.a.should == 'a'
    custom_method_called.should == false
    @processpagetest.b.should == 'b'
    custom_method_called.should == true
  end

  it 'should support defining the process page submit method' do
    process_page = @processpagealias.process_page('page 1')
    process_page.alias.should == ['page a', 'page b']
  end
  
  it 'should be able to report all process pages' do
    @processpage.process_pages[0].name.should == ''
    @processpage.process_pages[1].name.should == 'page 1'
    @processpage.process_pages[2].name.should == 'page 2'
    @processpage.process_pages.size.should == 3
  end
  
  it 'should include process page keywords in subclasses' do
    @processpagesubclass.process_pages[0].name.should == ''
    @processpagesubclass.process_pages[1].name.should == 'page 1'
    @processpagesubclass.process_pages[2].name.should == 'page 2'
    @processpagesubclass.process_pages[3].name.should == ''
    @processpagesubclass.process_pages[4].name.should == 'page 3'
    @processpagesubclass.process_pages.size.should == 5
    @processpagesubclass.keywords.should == [:a, :b, :c]
  end

  it 'should honor overriding default process page behavior' do
    @processpagesubclass.c.should == 'c'
    @processpagesubclass.class.instance_variable_get(:@process_page_active_page_method).should_not be_kind_of(Proc)
    @processpagesubclass.class.instance_variable_get(:@process_page_navigate_method).should_not be_kind_of(Proc)
    @processpagesubclass.class.instance_variable_get(:@process_page_submit_method).should_not be_kind_of(Proc)

    @processpagecustomnav.d.should == 'd'
    @processpagecustomnav.class.instance_variable_get(:@process_page_active_page_method).should be_kind_of(Proc)
    @processpagecustomnav.class.instance_variable_get(:@process_page_navigate_method).should be_kind_of(Proc)
    @processpagecustomnav.class.instance_variable_get(:@process_page_submit_method).should  be_kind_of(Proc)
  end
end




