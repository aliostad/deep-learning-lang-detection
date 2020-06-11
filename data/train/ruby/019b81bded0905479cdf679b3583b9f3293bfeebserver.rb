require "pry"
require "sinatra"
require "sinatra/reloader"

require_relative 'models/save.rb'
require_relative 'models/calculate.rb'

get "/" do
	erb(:index)
end


post "/calculate" do
	operation = Calculate.new(params[:n1], params[:n2],params[:btn])
	result = operation.calculate
	redirect to("/review/#{operation.n1}#{operation.change_button}#{operation.n2}/#{result}")
end

get "/review/:operation/:result" do
	@operation = params[:operation]
	@result = params[:result]
	@output = "The result of #{@operation} is #{@result}"
	erb(:review)
end

get "/add" do
	erb(:add)
end

post "/calculate_add" do
	first = params[:n1].to_f
	second = params[:n2].to_f
	result = first + second
	"#{first} + #{second} = #{result}"
end