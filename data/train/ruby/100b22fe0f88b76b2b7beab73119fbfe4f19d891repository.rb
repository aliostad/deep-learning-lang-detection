module Swapz
  class Repository
    def self.register(config)
      @@repositories ||= {}
      config.each do |type, klass|
        @@repositories[type.to_sym] = klass.to_s.constantize.new
      end
    end
    
    def self.repositories
      register({
        :account => 'Swapz::Mongodb::Repository::Account',
        :client => 'Swapz::Mongodb::Repository::Client',
        :code => 'Swapz::Mongodb::Repository::Code',
        :component => 'Swapz::Mongodb::Repository::Component',
        :customer => 'Swapz::Mongodb::Repository::Customer',
        :developer => 'Swapz::Mongodb::Repository::Developer',
        :inventory => 'Swapz::Mongodb::Repository::Inventory',
        :item => 'Swapz::Mongodb::Repository::Item',
        :plan => 'Swapz::Mongodb::Repository::Plan',
        :session => 'Swapz::InMemory::Repository::Session',
        :store => 'Swapz::Mongodb::Repository::Store',
        :token => 'Swapz::Mongodb::Repository::Token',
        :tax => 'Swapz::Mongodb::Repository::Tax',
        :till => 'Swapz::Mongodb::Repository::Till',
        :transaction => 'Swapz::Mongodb::Repository::Transaction',
        :user => 'Swapz::Mongodb::Repository::User'
      }) unless defined?(@@repositories)
      @@repositories
    end

    def self.for(type)
      repositories[type]
    end
  end
end