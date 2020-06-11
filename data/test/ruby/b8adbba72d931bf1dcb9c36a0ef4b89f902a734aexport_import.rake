namespace :data do

  task :export, [:api_host, :api_version] => :environment do |t, args|
    api_host = args[:api_host]
    api_version = args[:api_version]
    api_host = ApiHost.new(name: api_host)
    api_version = ApiVersion.new(api_host: api_host, name: api_version)
    exported = api_version.export
    puts "Exported: #{exported}"
  end

  task :import, [:api_host, :exported_file] => :environment do |t, args|
    api_host = args[:api_host]
    exported_file = args[:exported_file]
    ApiVersion.import(api_host, exported_file)
  end

  task :clear, [:api_host, :api_version] => :environment do |t, args|
    api_host = args[:api_host]
    api_version = args[:api_version]

    api_host = ApiHost.new(name: api_host)
    api_version = ApiVersion.new(api_host: api_host, name: api_version)
    api_version.clear!
  end

end