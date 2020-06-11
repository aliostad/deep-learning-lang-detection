class Path
  require 'uri'

  attr_accessor :parent_repository, :uri, :path, :revision, :externals, :repository_root

  def initialize(uri, revision, repository_root, parent_repository=nil)
    self.parent_repository = parent_repository
    self.uri = URI("#{uri}@#{revision}")
    self.revision = revision
    self.repository_root = repository_root
    # The path is the entire uri path minus the repository_root,
    # host, repository name
    self.path = self.uri.to_s.gsub(self.repository_root, '')
    self.externals = []
  end

  def to_s
    self.path
  end
end
