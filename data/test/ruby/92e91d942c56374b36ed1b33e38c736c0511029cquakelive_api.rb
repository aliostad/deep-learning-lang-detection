require "quakelive_api/version"
require "quakelive_api/base"
require "quakelive_api/game_time"
require "quakelive_api/items/structurable"
require "quakelive_api/items/award"
require "quakelive_api/items/favourite"
require "quakelive_api/items/recent_game"
require "quakelive_api/items/competitor"
require "quakelive_api/items/model"
require "quakelive_api/items/weapon"
require "quakelive_api/items/record"
require "quakelive_api/parser/base"
require "quakelive_api/parser/summary"
require "quakelive_api/parser/statistics"
require "quakelive_api/parser/awards"
require "quakelive_api/profile"
require "quakelive_api/profile/statistics"
require "quakelive_api/profile/summary"
require "quakelive_api/profile/awards/base"
require "quakelive_api/profile/awards/career_milestones"
require "quakelive_api/profile/awards/experience"
require "quakelive_api/profile/awards/mad_skillz"
require "quakelive_api/profile/awards/social_life"
require "quakelive_api/profile/awards/sweet_success"
require "quakelive_api/error/player_not_found"
require "quakelive_api/error/request_error"
require "net/http"
require "nokogiri"
require "date"
require "time"

module QuakeliveApi

  def self.site
    "http://www.quakelive.com"
  end

end
