require File.dirname(__FILE__) + '/boot'
require File.dirname(__FILE__) + '/lib/model'
require File.dirname(__FILE__) + '/lib/prototype_controller'
require 'test/unit'

class ControllerPrototypingTest < Test::Unit::TestCase

  def test_set_controller_prototype_class_name
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    assert_equal 'PrototypeController', ControllerPrototyping::Factory::prototype_class_name
  end

  def test_create_controller_class
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    controller_class = ControllerPrototyping::Factory::create_controller_class(:models)
    assert_equal 'PrototypeController', controller_class.name
  end

  def test_controller_class_model_class
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    controller_class = ControllerPrototyping::Factory::create_controller_class(:models)
    assert_equal Model, controller_class.model_class
  end

  def test_controller_class_resources_name
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    controller_class = ControllerPrototyping::Factory::create_controller_class(:models)
    assert_equal 'models', controller_class.resources_name
  end

  def test_controller_instance_model_class
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    controller_class = ControllerPrototyping::Factory::create_controller_class(:models)
    controller = controller_class.new
    assert_equal Model, controller.model_class
  end

  def test_controller_instance_resources_name
    ControllerPrototyping::Factory::prototype_class_name = :PrototypeController
    controller_class = ControllerPrototyping::Factory::create_controller_class(:models)
    controller = controller_class.new
    assert_equal 'models', controller.resources_name
  end
end
