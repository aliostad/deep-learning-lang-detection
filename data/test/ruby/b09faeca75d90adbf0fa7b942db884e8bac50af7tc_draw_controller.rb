$: << File.expand_path(File.dirname(__FILE__) + "/../lib")
$: << File.expand_path(File.dirname(__FILE__) + "/../")
require "test/unit"  
require "web_draw_binary_tree_controller"

class TestDrawController < Test::Unit::TestCase
  
  Request = Struct.new(:path_info)
  
  def test_return_javascript
    controller = DrawTreeController.new()
    controller.random_tree(5)
    assert(controller.html_warning_message == "")
    assert(controller.javascript_draw != "")
    assert_equal(5, controller.nodes)
  end
  
  def test_too_many_nodes   
    controller = DrawTreeController.new()
    controller.random_tree(5000)    
    assert(controller.html_warning_message != "")
    assert(controller.nodes < 5000)
 end
  
  def test_negative_nodes   
    controller = DrawTreeController.new()
    controller.random_tree(-9)
    assert(controller.html_warning_message != "")
    assert(controller.nodes > 0)
  end
  
end
