require 'kaminari'
require 'responders'
require 'inherited_resources'
require 'simple_form'
require 'jquery-rails'
require 'zurb-foundation'
require 'devise'
require 'slim'
require 'search_object'

module Manage
  class Engine < ::Rails::Engine
    isolate_namespace Manage

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.assets false
      g.helper false
    end

    initializer "manage.load_app_root" do |app|
      Manage.app_root = app.root
    end

    config.after_initialize do
      my_engine_root = Manage::Engine.root.to_s
      paths = ActionController::Base.view_paths.collect{|p| p.to_s}

      custom_resources =  File.join(my_engine_root, '/app/views/manage/resource')
      paths = paths.insert(paths.index(my_engine_root + '/app/views'), custom_resources)
      ActionController::Base.view_paths = paths
    end

  end
end
