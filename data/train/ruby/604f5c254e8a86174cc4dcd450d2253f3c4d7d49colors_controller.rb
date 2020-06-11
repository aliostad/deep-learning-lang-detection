class ColorsController < ApplicationController

	def red
		api_key = ENV['SECRET_TOKEN']
		@dress = Api.new("http://api.shopstyle.com/api/v2/products/439800784?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/430085694?pid=#{api_key}")
	end

	def green
		api_key = ENV['SECRET_TOKEN']
		@dress = Api.new("http://api.shopstyle.com/api/v2/products/431070948?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/442023276?pid=#{api_key}")
	end

	def purple
		api_key = ENV['SECRET_TOKEN']
		@dress = Api.new("http://api.shopstyle.com/api/v2/products/441487419?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/430085694?pid=#{api_key}")
	end

	def red_work
		api_key = ENV['SECRET_TOKEN']
		@skirt = Api.new("http://api.shopstyle.com/api/v2/products/442023246?pid=#{api_key}")
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/438892272?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/429957599?pid=#{api_key}")
	end

	def green_work
		api_key = ENV['SECRET_TOKEN']
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/444410796?pid=#{api_key}")
		@pants = Api.new("http://api.shopstyle.com/api/v2/products/439344889?pid=#{api_key}")
	end

	def purple_work
		api_key = ENV['SECRET_TOKEN']
		@dress = Api.new("http://api.shopstyle.com/api/v2/products/438325480?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/348980288?pid=#{api_key}")
	end

	def red_casual
		api_key = ENV['SECRET_TOKEN']
		@jeans = Api.new("http://api.shopstyle.com/api/v2/products/429968030?pid=#{api_key}")
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/433660689?pid=#{api_key}")
	end

	def green_casual
		api_key = ENV['SECRET_TOKEN']
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/438328032?pid=#{api_key}")
		@pants = Api.new("http://api.shopstyle.com/api/v2/products/443063950?pid=#{api_key}")
	end

	def purple_casual
		api_key = ENV['SECRET_TOKEN']
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/443247227?pid=#{api_key}")
		@pants = Api.new("http://api.shopstyle.com/api/v2/products/444377500?pid=#{api_key}")
	end

	def mred
		api_key = ENV['SECRET_TOKEN']
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/453624160?pid=#{api_key}")
		@pants = Api.new("http://api.shopstyle.com/api/v2/products/453486615?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/453550192?pid=#{api_key}")
	end

	def mgreen
		@green = "green"
	end

	def mpurple
		@purple = "purple"
	end

	def mred_work
		api_key = ENV['SECRET_TOKEN']
		@shirt = Api.new("http://api.shopstyle.com/api/v2/products/453624160?pid=#{api_key}")
		@pants = Api.new("http://api.shopstyle.com/api/v2/products/453486615?pid=#{api_key}")
		@shoe = Api.new("http://api.shopstyle.com/api/v2/products/453550192?pid=#{api_key}")
	end

	def mgreen_work
		@green_work = "green work"
	end

	def mpurple_work
		@purple_work = "purple work"
	end

	def mred_casual
		@red_casual = "red casual"
	end

	def mgreen_casual
		@green_casual = "red casual"
	end

	def mpurple_casual
		@purple_casual = "red casual"
	end
end