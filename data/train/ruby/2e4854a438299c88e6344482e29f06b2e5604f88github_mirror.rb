# encoding: utf-8
require 'rack'
require 'json'

# A Rack application to handle hooks from Github to
# mirroring repositories
class GithubMirror
  class GithubMirrorError < StandardError # :nodoc:
  end

  def initialize
    @config_file_path = File.expand_path('../../config/config.yml', __FILE__)
  end

  # Rack API method
  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    handle_request

    @response.finish
  end

  private

  # Load configuration from file
  def config
    @config ||= YAML.load_file(@config_file_path)
  end

  # Return an object with reader method for allowed, path and patterns
  # attributes builded from configuration file.
  #
  # Merge from configuration file in following order:
  # - repository_owner/repository_name
  # - repository_owner/repository_name*
  # - repository_owner/*
  # - repository_owner/*
  # - repository_owner*/*
  # - */*
  def repository_info(repository_owner, repository_name, reload = false)
    if @repository_info.nil? || reload
      @repository_info = {}

      @repository_info.default_proc = proc {|hash, repository|
        hash[repository] = RepositoryInfo.new(false, nil, {})

        matches = (config['repositories'] || {}).select do |pattern, value|
          repository =~ /^#{ pattern.gsub(/^([^\/]+\/)??\*+/, '\1[^/]+').gsub(/\*+/, '[^/]*') }$/
        end
        exact_match = matches.delete(repository) || {}

        hash[repository].members.each do |key|
          matches.sort {|a, b| a.first <=> b.first }.map {|v| v.last}.each do |match|
            hash[repository][key] = match[key.to_s] if match.has_key?(key.to_s) && !match[key.to_s].nil?
          end
          hash[repository][key] = exact_match[key.to_s] if exact_match.has_key?(key.to_s) && !exact_match[key.to_s].nil?
        end
        hash[repository].freeze

        hash[repository]
      }
    end

    @repository_info["#{repository_owner}/#{repository_name}"]
  end
  RepositoryInfo = Struct.new(:allowed, :path, :patterns) # :nodoc:

  # Return a expanded path to repository mirror build with information
  # from configuration for repository. Replace keywords (:keyword) with
  # value matched by it pattern.
  def mirror_path(repository_owner, repository_name)
    mirror_path = repository_info(repository_owner, repository_name).path || raise(GithubMirrorError, "Path for repository '#{repository_owner}/#{repository_name}' doesn\'t exist in config")
    mirror_patterns = repository_info(repository_owner, repository_name).patterns

    keys = mirror_path.scan(/:(\w+)/).flatten
    unless keys.empty?
      keys.each do |key|
        if key == 'repository_name' && !mirror_patterns.has_key?('repository_name')
          value = repository_name
        elsif key == 'repository_owner' && !mirror_patterns.has_key?('repository_owner')
          value = repository_owner
        else
          value = repository_name.match(mirror_patterns[key])[1] rescue raise(GithubMirrorError, "Repository name pattern have an error for key `#{key}`: #{mirror_patterns[key] || 'no pattern'}")
        end
        mirror_path.gsub!(/:#{key}/, value)
      end
    else
      mirror_path = File.join(mirror_path, "#{repository_owner}/#{repository_name}.git")
    end
    mirror_path += '.git' unless mirror_path.match(/\.git$/)

    mirror_path
  end

  # Handle request from Github, return always success response, but write an error
  # message in body if an error raised
  def handle_request
    raise GithubMirrorError, 'Only POST request allowed' unless @request.post? # return fail message if request is not a POST
    raise GithubMirrorError, 'Token not match' if config['token'] && !@request.path_info.end_with?('/' + config['token'])

    payload = JSON.parse(@request[:payload]) rescue raise(GithubMirrorError, 'Payload param need to be present and a valid JSON string')

    # get informations about repository
    repository_owner   = payload['repository']['owner']['name'] rescue raise(GithubMirrorError, 'Repository owner name required')
    repository_name    = payload['repository']['name']          rescue raise(GithubMirrorError, 'Repository name required')

    repository_private = payload['repository']['private'] == '1' ? true : false

    # check if repository can be mirrored
    unless repository_info(repository_owner, repository_name).allowed
      raise(GithubMirrorError, "Repository #{repository_owner}/#{repository_name} is not allowed to be mirrored")
    end

    # generate url (for private or public project)
    if repository_private
      repository_url = "git@github.com:#{repository_owner}/#{repository_name}.git"
    else
      repository_url = "git://github.com/#{repository_owner}/#{repository_name}.git"
    end

    # get mirror path
    repository_path = mirror_path(repository_owner, repository_name)

    # clone repository if mirror doesn't exist
    unless File.exist?(repository_path)
      system("git clone --mirror --origin github_mirroring #{repository_url} #{repository_path}")

    # fetch repository if mirror already exist
    else
      if `cd #{repository_path}; git remote` !~ /github_mirroring/
        system("cd #{repository_path}; git remote add --mirror github_mirroring #{repository_url}")
      end
      system("cd #{repository_path}; git fetch github_mirroring")
    end

    # end
    @response.write 'done'
  rescue GithubMirrorError => e
    @response.write "fail: #{e.message}"
  end
end