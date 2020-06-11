# Define a subclass of Ramaze::Controller holding your defaults for all
# controllers

class Controller < Ramaze::Controller
    layout :default
    engine :Markaby
    helper :markabatter
    helper :authenticator
    helper :codebatter
    helper :tagalator
end

# Here go your requires for subclasses of Controller:
require 'controller/main'
require 'controller/admin'
require 'controller/admin_notes'
require 'controller/admin_codes'
require 'controller/admin_links'
require 'controller/admin_projects'
require 'controller/admin_users'
require 'controller/tags'
require 'controller/logs'
require 'controller/projects'
require 'controller/links'
require 'controller/codes'