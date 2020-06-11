require 'json'
require 'curb'

module SeafileApi
  class Connect

    attr_accessor :user_name
    attr_accessor :password
    attr_accessor :host
    attr_accessor :repo
    attr_accessor :token

    def initialize(user_name ,password,host,repo)
      self.user_name  = user_name
      self.password   = password
      self.host       = host
      self.repo       = repo
      self.token      = self.get_token
    end

  end

end
require "seafile-api/file/post_operations"
require "seafile-api/message"
require "seafile-api/group"
require "seafile-api/directory"
require "seafile-api/group/group"
require "seafile-api/group/group_member"
require "seafile-api/group/group_message"
require "seafile-api/account"
require "seafile-api/starred"
require "seafile-api/share"
require "seafile-api/library"
require "seafile-api/library/del_library"
require "seafile-api/library/get_library"
require "seafile-api/library/post_library"
require "seafile-api/shared/share"
require "seafile-api/shared/shared_files"
require "seafile-api/shared/shared_libraries"
require "seafile-api/file/dry_methods"
require "seafile-api/file/file_operations"
require "seafile-api/file/get_operations"
require "seafile-api/file"
