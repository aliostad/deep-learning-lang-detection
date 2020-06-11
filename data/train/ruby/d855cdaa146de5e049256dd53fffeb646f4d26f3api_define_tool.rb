module Okcoin
  module ApiDefineTool

    def define_get_api(*api_names)
      api_names.each do |api_name|
        define_method(api_name) do |**params|
          params.reject! do |k, v| v.blank? end
          http_get(@url+"v1/#{api_name}.do", params)
        end
      end
    end

    def define_post_api(*api_names)
      api_names.each do |api_name|
        define_method(api_name) do |**params|
          params.reject! do |k, v| v.blank? end
          params[:api_key] = @api_key
          params[:sign] = sign(params)
          http_post(@url+"v1/#{api_name}.do", params)
        end
      end
    end

  end
end