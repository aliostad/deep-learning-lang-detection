class WformalitemsController < ApplicationController

    def index
      api_key = ENV['SECRET_TOKEN']
      @dress = Api.new("http://api.shopstyle.com/api/v2/products/435600240?pid=#{api_key}")
      @shoe = Api.new("http://api.shopstyle.com/api/v2/products/430985995?pid=#{api_key}")
      @lip = Api.new("http://api.shopstyle.com/api/v2/products/280047382?pid=#{api_key}")
      @ear = Api.new("http://api.shopstyle.com/api/v2/products/299061489?pid=#{api_key}")
    end

    def create
      @formal_image = Filter.new(params[:filter])
      @formal_image.save
    end


    def page2
      api_key = ENV['SECRET_TOKEN']
      @dress1 = Api.new("http://api.shopstyle.com/api/v2/products/402825252?pid=#{api_key}")
      @shoe1 = Api.new("http://api.shopstyle.com/api/v2/products/344233213?pid=#{api_key}")
      @lip1 = Api.new("http://api.shopstyle.com/api/v2/products/414808558?pid=#{api_key}")
      @ear1 = Api.new("http://api.shopstyle.com/api/v2/products/434246782?pid=#{api_key}")
    end

    def page3
      api_key = ENV['SECRET_TOKEN']
      @dress2 = Api.new("http://api.shopstyle.com/api/v2/products/434650977?pid=#{api_key}")
      @shoe2 = Api.new("http://api.shopstyle.com/api/v2/products/431935505?pid=#{api_key}")
      @lip2 = Api.new("http://api.shopstyle.com/api/v2/products/403147939?pid=#{api_key}")
      @ear2 = Api.new("http://api.shopstyle.com/api/v2/products/437596367?pid=#{api_key}")
    end

    def page4
      api_key = ENV['SECRET_TOKEN']
      @dress3 = Api.new("http://api.shopstyle.com/api/v2/products/436008127?pid=#{api_key}")
      @shoe3 = Api.new("http://api.shopstyle.com/api/v2/products/439353531?pid=#{api_key}")
      @lip3 = Api.new("http://api.shopstyle.com/api/v2/products/362146916?pid=#{api_key}")
      @ear3 = Api.new("http://api.shopstyle.com/api/v2/products/436630512?pid=#{api_key}")
    end

end