require "uri"
require "net/http"
require "json"

require "NYTimesAPI/version"

module NYTimesAPI
  autoload :Util,             "NYTimesAPI/util"

  autoload :ArticleSearch,    "NYTimesAPI/article_search"
  autoload :BestSellers,      "NYTimesAPI/best_sellers"
  autoload :CampaignFinance,  "NYTimesAPI/campaign_finance"
  autoload :Community,        "NYTimesAPI/community"
  autoload :Congress,         "NYTimesAPI/congress"
  autoload :Districts,        "NYTimesAPI/districts"
  autoload :EventListings,    "NYTimesAPI/event_listings"
  autoload :Geographic,       "NYTimesAPI/geographic"
  autoload :MostPopular,      "NYTimesAPI/most_popular"
  autoload :MovieReviews,     "NYTimesAPI/movie_reviews"
  autoload :RealState,        "NYTimesAPI/real_state"
  autoload :Semantic,         "NYTimesAPI/semantic"
  autoload :TimesNewswire,    "NYTimesAPI/times_newswire"
  autoload :Timestags, "      NYTimesAPI/timestags"
end
