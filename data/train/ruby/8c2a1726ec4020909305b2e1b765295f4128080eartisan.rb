require 'artisan/project'
require 'artisan/iteration'
require 'artisan/iteration_total_billed_points_by_craftsman'
require 'artisan/story'
require 'artisan/query'
require 'artisan/signoff_pdf'
require 'json'

module Artisan
  def self.get_project(key, address = 'artisan.8thlight.com')
    response = Query.get_project(key, address)
    json_chunk = JSON::parse(response)
    return Project.new(json_chunk)
  end

  def self.get_iterations(key, address = 'artisan.8thlight.com')
    response = Query.get_iterations(key, address)
    json_chunk = JSON::parse(response)

    @iterations = []
    json_chunk.collect { |iteration_chunk| @iterations << Iteration.new(iteration_chunk) }

    return @iterations
  end

  def self.get_iteration_total_billed_points_by_craftsman(key, iteration_number, address = 'artisan.8thlight.com')
    response = Query.get_iteration_total_billed_points_by_craftsman(key, iteration_number, address)
    json_chunk = JSON::parse(response)
    return IterationTotalBilledPointsByCraftsman.new(json_chunk)
  end

  def self.get_signoff_pdf(key, iteration_id, address = 'artisan.8thlight.com')
    response = Query.get_signoff_pdf(key, iteration_id, address)

    return SignoffPdf.new :raw_pdf => response
  end

  def self.get_stories(key, address = 'artisan.8thlight.com')
    response = Query.get_stories(key, address)
    json_chunk = JSON::parse(response)

    @stories = []
    json_chunk.collect { |story_chunk| @stories << Story.new(story_chunk) }

    return @stories
  end

  def self.get_stories_by_iteration(key, iteration_number, address = 'artisan.8thlight.com')
    response = Query.get_stories_by_iteration(key, iteration_number, address)
    json_chunk = JSON::parse(response)

    @stories = []
    json_chunk.collect { |story_chunk| @stories << Story.new(story_chunk) }

    return @stories
  end

  def self.get_backlog_stories(key, address = 'artisan.8thlight.com')
    response = Query.get_backlog_stories(key, address)
    json_chunk = JSON::parse(response)

    @stories = []
    json_chunk.collect { |story_chunk| @stories << Story.new(story_chunk) }

    return @stories
  end

  def self.update_estimates(key, story, address = 'artisan.8thlight.com')
    response = Query.update_estimates(key, story, address)
  end

  def self.authenticate(username, password, address = 'artisan.8thlight.com')
    response = Query.authenticate(username, password, address)
    JSON::parse(response)["success"]
  end
end
