require 'test_helper'

class RoutesTest < ActionController::TestCase

  test 'proper_api_specification' do
    assert_routing({:method => 'get', :path => 'annotator_api'}, {:controller => 'annotator_api', :action => 'root'})
    assert_routing({:method => 'get', :path => 'annotator_api/annotations'}, {:controller => 'annotator_api', :action => 'index'})
    assert_routing({:method => 'get', :path => 'annotator_api/annotations/1'}, {:controller => 'annotator_api', :action => 'read', :id => '1'})
    assert_routing({:method => 'post', :path => 'annotator_api/annotations'}, {:controller => 'annotator_api', :action => 'create'})
    assert_routing({:method => 'put', :path => 'annotator_api/annotations/1'}, {:controller => 'annotator_api', :action => 'update', :id => '1'})
    assert_routing({:method => 'delete', :path => 'annotator_api/annotations/1'}, {:controller => 'annotator_api', :action => 'delete', :id => '1'})
    assert_routing({:method => 'get', :path => 'annotator_api/search', :query => {:text => 'foobar'}}, {:controller => 'annotator_api', :action => 'search'})
  end

end