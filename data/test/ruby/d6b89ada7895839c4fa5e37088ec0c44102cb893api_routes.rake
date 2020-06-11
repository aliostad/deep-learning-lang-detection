#http://stackoverflow.com/a/27476354/717506

task :all_routes => [:routes, :api_routes]

task :api_routes => :environment do
  longest_uri  = HerebyAPI.routes.map{|api|api.route_path.length}.max
  longest_desc = HerebyAPI.routes.map{|api|api.route_description.length}.max
  pattern = "%28s %-#{longest_uri}s %-#{longest_desc}s\n"

  # print column headers
  printf(
    pattern,
    "Verb", "URI Pattern", "Description"
  ) if t

  # print each column
  HerebyAPI.routes.each do |api|
    printf(
      pattern,
      api.route_method, api.route_path, api.route_description
    )
  end
end