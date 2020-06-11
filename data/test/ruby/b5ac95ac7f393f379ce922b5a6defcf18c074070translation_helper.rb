# encoding: utf-8
module TranslationHelper
  
  def translate_controller(options = {})
    controller = options[:controller] || params[:controller]
    translate :title, :scope => [:controller, controller], :default => ''
  end
  
  def translate_action(options = {})
    controller = options[:controller] || params[:controller]
    action = options[:action] || params[:action]
    translate action, :scope => [:controller, controller, :action], :default => ''
  end
  
  def translate_yahoo_message(msg)
    translate msg, :scope => [:yahoo, :message], :default => msg
  end
end