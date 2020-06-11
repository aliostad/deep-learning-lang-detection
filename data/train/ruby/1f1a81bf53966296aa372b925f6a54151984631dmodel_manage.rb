require 'ostruct'

if defined?(Mongoid::Document)
  require 'model_manage/form'              if defined?(SimpleForm) || defined?(Formtastic)
  require 'model_manage/mongoid_rails_erd' if defined?(RailsERD)
  require 'model_manage/mongoid'
end

if defined?(ActiveRecord::Base)
  require 'model_manage/active_record_rails_erd' if defined?(RailsERD)
  require 'model_manage/active_record'
end

require 'model_manage/rails'
require 'model_manage/bitfield'
require 'model_manage/base'

if defined?(Rails)
module ModelManage
  class Engine < ::Rails::Engine
  end
end
end
