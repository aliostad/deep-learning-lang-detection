require 'thor'

module CloudConductorCli
  class Client < Thor
    register Models::Account, 'account', 'account', 'Subcommand to manage accounts'
    register Models::Token, 'token', 'token', 'Subcommand to manage token of accounts'
    register Models::Project, 'project', 'project', 'Subcommand to manage projects'
    register Models::Cloud, 'cloud', 'cloud', 'Subcommand to manage clouds'
    register Models::BaseImage, 'base_image', 'base_image', 'Subcommand to manage base_image'
    register Models::Pattern, 'pattern', 'pattern', 'Subcommand to manage pattern'
    register Models::Blueprint, 'blueprint', 'blueprint', 'Subcommand to manage blueprints'
    register Models::System, 'system', 'system', 'Subcommand to manage systems'
    register Models::Environment, 'environment', 'environment', 'Subcommand to manage environments'
    register Models::Application, 'application', 'application', 'Subcommand to manage applications'
    register Models::Role, 'role', 'role', 'Subcommand to manage role'
    register Models::Audit, 'audit', 'audit', 'Subcommand to manage audits'

    desc 'version', 'Show version number'
    def version
      puts "CloudConductor CLI Version #{VERSION}"
    end
    map %w(-v --version) => :version
  end
end
