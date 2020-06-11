desc "API Routes"
task api_routes: :environment do
  # get mount API path in Rails app
  # /api
  api_path = Rails.application.routes.routes.named_routes["apis"].
              path.build_formatter.instance_variable_get(:@parts)
  api_path = (api_path.length > 1) ? api_path.join : ""
  # if ["/"] => "" else ["/", "api"] => "/api"
  APIS.routes.each do |api|
    method = api.route_method.ljust(10)   # GET

    path = api.route_path                 # /:version/courses
    version = api.route_version           # v1
    path[":version"] = version if version # /:version/courses -> /v1/courses

    puts "#{version}     #{method} #{api_path}#{path}"
  end
end