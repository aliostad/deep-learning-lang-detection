require 'log4r'
require 'mail'
require 'sendgrid_api/configurable'
require 'sendgrid_api/delivery_methods/sendgrid'
require 'sendgrid_api/error'
require 'sendgrid_api/error/authentication_error'
require 'sendgrid_api/error/configuration_error'
require 'sendgrid_api/error/delivery_error'
require 'sendgrid_api/error/options_error'
require 'sendgrid_api/error/parser_error'
require 'sendgrid_api/client'
require 'sendgrid_api/methods/sub_user'
require 'sendgrid_api/methods/mail'
require 'sendgrid_api/result'
require 'sendgrid_api/x_smtp'

module SendgridApi
  class << self
    include SendgridApi::Configurable
  end
end

SendgridApi.setup