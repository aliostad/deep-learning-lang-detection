module Ancor
  module CLI
    class Front < Base
      desc 'version', 'Displays the version of the ANCOR server'
      def version
        parsed = JSON.parse(connection.version.body)
        puts 'ANCOR version ' + parsed['version']
      end

      desc 'goal <subcommand>', 'Manage goals'
      subcommand 'goal', Goal

      desc 'environment <subcommand>', 'Manage environments'
      subcommand 'environment', Environment

      desc 'role <subcommand>', 'Manage roles'
      subcommand 'role', Role

      desc 'task <subcommand>', 'Manage tasks'
      subcommand 'task', Task

      desc 'instance <subcommand>', 'Manage instances'
      subcommand 'instance', Instance
    end # Front
  end # CLI
end
