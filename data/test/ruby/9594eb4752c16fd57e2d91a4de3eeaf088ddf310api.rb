default.applications[:api][:name]           = 'pickwick-api'
default.applications[:api][:repository]     = 'https://github.com/OPLZZ/pickwick-api.git'
default.applications[:api][:revision]       = 'master'
default.applications[:api][:url]            = 'pickwick-api.dev.vhyza.eu api.damepraci.cz'
default.applications[:api][:port]           = 80
default.applications[:api][:environment]    = 'production'

default.applications[:api][:puma][:threads][:min]         = 1
default.applications[:api][:puma][:threads][:max]         = 6
default.applications[:api][:puma][:directories][:sockets] = "/var/run/puma/sockets"
default.applications[:api][:puma][:directories][:pids]    = "/var/run/puma/pids"
default.applications[:api][:puma][:wait]                  = 120
