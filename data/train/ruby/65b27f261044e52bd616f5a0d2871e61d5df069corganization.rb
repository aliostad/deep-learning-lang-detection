require_relative 'github/github.rb'

class Organization
  def initialize organization_id = nil, repository_id = nil, access_token = nil
    @repository = get_repository(organization_id, repository_id, access_token)
  end

  def self.get organization_id = nil, repository_id = nil, access_token = nil
    Organization.new(organization_id, repository_id, access_token)
  end

  def post id = nil
    @repository.post id
  end

  def posts filter
    @repository.posts filter
  end

  def tags filter
   @repository.tags filter
  end

  def get_repository organization_id, repository_id, access_token
    Github.new organization_id, repository_id, access_token
  end
end
