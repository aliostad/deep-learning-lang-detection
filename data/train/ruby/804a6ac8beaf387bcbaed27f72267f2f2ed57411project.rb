require 'git_api'
class Project < ActiveRecord::Base
  belongs_to :user
  validates_presence_of   :name
  validates_uniqueness_of :name

  after_create    :create_repository
  after_update    :update_repository
  before_destroy  :destroy_repository

  private
    def create_repository
      logger.debug("************* Create repository #{repository_name} *************")
      (a, b, c) = GitAPI.action(:init, :user => self.user.login, :repository => repository_name)
      logger.debug("************* #{c.gets} : #{b.gets} ***#{a}**")
    end

    def update_repository
      logger.debug("************* Update project #{name} *****")
      GitAPI.action(:rename, :user => self.user.login, :repository => repository_name, :new_repository => repository_name)
    end

    def destroy_repository
      GitAPI.action(:delete, :user => self.user.login, :repository => repository_name)
    end

    def repository_name
      "#{name}.git"
    end
end