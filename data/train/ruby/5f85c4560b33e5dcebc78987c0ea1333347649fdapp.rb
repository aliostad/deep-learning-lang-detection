Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'sinatra'
require 'sinatra/config_file'
require "sinatra/reloader" if development?

require_relative 'commons'

setup 'config.yml'

require_relative 'api'

api = @api

get '/' do
    redirect "#{settings.base}/index.html"
end

get '/api-docs' do
    re = api.clone
    re[:apis] = api[:apis].map { |api| {:path=>api[:path],:description=>api[:description]}}
    re.to_json
end

get '/api-docs/:path' do

    re = {
        :apiVersion=>api[:apiVersion],
        :swaggerVersion=>api[:swaggerVersion],
        :resourcePath=>"/#{params[:path]}",
        :produces=>["application/json"],
        :apis=>[]
        }

    api[:apis].each { |api| 
        if api[:path] == "/#{params[:path]}" then 
            re[:apis] = api[:apis]; 
        end
    }

    re.to_json
end

api[:apis].each { |resource| 
    resource[:apis].each { |api|
        path = api[:path].gsub(/{(\w+)}/,':\1').gsub("../","")
        get path do
            r = {}
            begin
                r = api[:operations][0][:execute].call(params)
            rescue Exception => e
                puts e
                puts e.backtrace
                r = nil
            end
            r.to_json
        end
    }
}

