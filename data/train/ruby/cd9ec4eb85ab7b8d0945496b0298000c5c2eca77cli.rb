require 'thor'
require 'chaos/commands'

module Chaos

  class CLI < Thor

    desc 'servicepacks', 'Manage services offering addons on servers'
    subcommand 'servicepacks', Chaos::Commands::Servicepacks

    desc 'server', 'Manage server configuration'
    subcommand 'server', Chaos::Commands::Server

    desc 'app', 'Manage app deployment configuration'
    subcommand 'app', Chaos::Commands::App

    desc 'domains', 'Manage domains attached to applications'
    subcommand 'domains', Chaos::Commands::Domains

    desc 'config', 'Manage app config vars'
    subcommand 'config', Chaos::Commands::Config

    desc 'addons', 'Manage app addons'
    subcommand 'addons', Chaos::Commands::Addons
  end
end