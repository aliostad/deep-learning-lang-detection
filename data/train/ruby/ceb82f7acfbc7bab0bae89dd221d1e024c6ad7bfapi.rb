module Zonomi
  module API

    SERVER = {
      domain: 'https://zonomi.com',
      prefix: '/app/dns',
      suffix: '.jsp',
      routes: {
        dyndns: '/dyndns',
        zone: {
          add: '/addzone',
          to_slave: '/converttosecondary',
          to_master: '/converttomaster',
        },
        ipchange: '/ipchange',
      }
    }

    require_relative "api/adapter"
    require_relative "api/client"
    require_relative "api/request"
    require_relative "api/action"
    require_relative "api/record"
    require_relative "api/zone"
    require_relative "api/result"

  end
end
