require 'curses'
require_relative 'controllers/controller'
require_relative 'controllers/home_controller'
require_relative 'controllers/tv_shows_controller'
require_relative 'controllers/seasons_controller'
require_relative 'controllers/episodes_controller'
require_relative 'controllers/links_controller'
require_relative 'ui/template'

module Popmovies
  class Application
    include Ui
    include Controllers

    def initialize
      @tmpl = Template.new

      @home_controller = HomeController.new
      @tv_shows_controller = TvShowsController.new
      @seasons_controller = SeasonsController.new
      @episodes_controller = EpisodesController.new
      @links_controller = LinksController.new

      @home_controller.router.on(:rendered) { @tv_shows_controller.render }

      @tv_shows_controller.router.on(:selected) do |tv_show|
        @seasons_controller.render(tv_show)
      end

      @seasons_controller.router.on(:selected) do |season|
        @episodes_controller.render(season)
      end

      @episodes_controller.router.on(:selected) do |episode|
        @links_controller.render(episode)
      end

      @links_controller.router.on(:exit) { Kernel.exit }
    end

    def run
      @home_controller.render
    ensure
      stop
    end

    def stop
      @tmpl.close
    end

  end
end
