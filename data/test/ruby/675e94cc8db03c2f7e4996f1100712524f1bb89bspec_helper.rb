require 'rspec'
require_relative '../lib/lc-api'
require_relative '../lib/lc-api/api'
require_relative '../lib/lc-api/error_codes'
require_relative '../lib/lc-api/resource'
require_relative '../lib/lc-api/resource/category'
require_relative '../lib/lc-api/resource/location'
require_relative '../lib/lc-api/resource/message'
require_relative '../lib/lc-api/resource/series'
require_relative '../lib/lc-api/resource/speaker'
require_relative '../lib/lc-api/resource/staff'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = 'documentation'
end