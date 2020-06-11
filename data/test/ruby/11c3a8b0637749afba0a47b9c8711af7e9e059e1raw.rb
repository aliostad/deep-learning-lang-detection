require 'rubygems'

require 'mailchimp'

API_KEY = ENV['api_key']
puts "api_key is: #{API_KEY}"
api = Mailchimp::API.new(API_KEY)

def list_for(api, name)
  api.lists['data'].find {|a| a['name'] == name }
end

list =  list_for(api, "LetsChat")
puts list.inspect

list_id = list['id']
10.times do
email =  "yolodude+yoloswag#{(rand*10000).to_i}@gmail.com"
puts "Adding: #{email}"
api.listSubscribe( {
  :id => list_id, 
  :email_address => email, 
  :merge_vars => Hash.new,
  :double_optin => false,
  :send_welcome => false
  }
)
  
end
