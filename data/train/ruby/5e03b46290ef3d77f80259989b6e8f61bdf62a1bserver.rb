require 'rubygems'
require 'sinatra'
require 'rack-api-key'
load "docker_api.rb"
#require 'JSON'

#hard coded for now, need to change it
#set :token,'apikey12345asdfg'

#$docker =  DockerApi.new

KEYS = {"complexkey"=>1,"key2"=>2}


get '/status' do
"endpoint is /api/"
end

get '/api/hello' do
"hello world"
end  

get '/api/version' do 
  DockerApi.new.version
end  


use RackApiKey, :api_key_proc => Proc.new { |val| KEYS[val] },
                :rack_api_key => "account.api.key",
                :header_key => "HTTP_X_CUSTOM_API_HEADER",
                :url_restriction => [/api/],
                :url_exclusion => [/status/]
                
# curl --header "X_CUSTOM_API_HEADER: key1" http://localhost:4567/api/hello                