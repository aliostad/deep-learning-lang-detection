require 'rubygems'
require 'active_support/core_ext/class/attribute'

class Api
  class_attribute :timeout

  def self.request
    puts "Request from #{name} will timeout in #{timeout} seconds"
  end
end

class TwitterApi < Api
end

class FacebookApi < Api
end

Api.request

Api.timeout = 60
Api.request


TwitterApi.request

TwitterApi.timeout = 200
TwitterApi.request

FacebookApi.timeout = nil
FacebookApi.request

Api.request
TwitterApi.request
FacebookApi.request

puts "Does Api have a timeout? " + (Api.timeout? ? "yes" : "no")
puts "Does TwitterApi have a timeout? " + (TwitterApi.timeout? ? "yes" : "no")
puts "Does FacebookApi have a timeout? " + (FacebookApi.timeout? ? "yes" : "no")