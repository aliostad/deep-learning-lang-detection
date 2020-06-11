require "three_seventy_api/api/content"
require "three_seventy_api/api/subscription"
require "three_seventy_api/api/campaign"
require "three_seventy_api/api/event_push_campaign"
require "three_seventy_api/api/contact"
require "three_seventy_api/api/contact_attribute"
require "three_seventy_api/api/account"

# API end points entry module.
module ThreeSeventyApi
  module Api

    # Include every end point here.
    include Content
    include Subscription
    include Campaign
    include EventPushCampaign
    include Contact
    include ContactAttribute
    include Account
  end
end
