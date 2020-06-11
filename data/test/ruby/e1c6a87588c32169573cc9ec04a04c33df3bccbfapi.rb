module Wowr
  module API
    autoload :API,        'wowr/api/api'
    autoload :Client,     'wowr/api/client'

    autoload :ArenaTeams, 'wowr/api/arena_teams'
    autoload :Calendar,   'wowr/api/calendar'
    autoload :Characters, 'wowr/api/characters'
    autoload :Dungeons,   'wowr/api/dungeons'
    autoload :GuildBank,  'wowr/api/guild_bank'
    autoload :Guilds,     'wowr/api/guilds'
    autoload :Items,      'wowr/api/items'

    # Returns a new instance of Wowr::API::API
    def self.new(options = {})
      # This is basically a hack to let us have a namespace called API without
      # breaking old code which calls API.new(...)
      API.new(options)
    end
  end
end
