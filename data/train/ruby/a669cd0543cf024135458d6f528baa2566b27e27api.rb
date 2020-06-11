module LinkedIn
  module API
    Dir[ File.expand_path('../api/**/*.rb', __FILE__) ].each { |f| require f }

    def self.included(base)
      base.send :include, LinkedIn::API::Authentication,
                          LinkedIn::API::Companies,
                          LinkedIn::API::Groups,
                          LinkedIn::API::Invitation,
                          LinkedIn::API::Jobs,
                          LinkedIn::API::Messaging,
                          LinkedIn::API::NetworkUpdates,
                          LinkedIn::API::People
    end
  end
end
