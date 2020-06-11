module Digitalocean
  module Manage
    class Cli < Thor

      extend Autoloaded

      include Acclimate::CliHelper

      desc 'droplet SUBCOMMAND', "Operations performed on droplets"
      subcommand "droplet", Digitalocean::Manage::Cli::Droplet

      desc 'image SUBCOMMAND', "Operations performed on images"
      subcommand "image", Digitalocean::Manage::Cli::Image

      desc 'key SUBCOMMAND', "Operations performed on keys"
      subcommand "key", Digitalocean::Manage::Cli::Key

      desc 'region SUBCOMMAND', "Operations performed on regions"
      subcommand "region", Digitalocean::Manage::Cli::Region

      desc 'size SUBCOMMAND', "Operations performed on sizes"
      subcommand "size", Digitalocean::Manage::Cli::Size

    end
  end
end
