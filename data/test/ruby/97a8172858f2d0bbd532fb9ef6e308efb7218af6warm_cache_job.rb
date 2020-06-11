class WarmCacheJob < ActiveJob::Base
  queue_as :default

  def perform(api_user, api_key)
    SoftlayerConnection.new(api_user, api_key)
    WarmDatacentersCacheJob.perform_later(api_user, api_key)
    WarmCreateOptionsCacheJob.perform_later(api_user, api_key)
    WarmPackageCacheJob.perform_later(api_user, api_key)
    WarmConfigurationCacheJob.perform_later(api_user, api_key)
    WarmProductCategoriesCacheJob.perform_later(api_user, api_key)
    WarmStoreHashCacheJob.perform_later(api_user, api_key)
  end
end
