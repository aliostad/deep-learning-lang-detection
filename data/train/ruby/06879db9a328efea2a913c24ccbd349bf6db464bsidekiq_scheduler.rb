if defined?(Sidekiq::CLI)
  require "./lib/stat_tracker.rb"
  require "./lib/monkeypatches/jruby_gc.rb"
  GC::Profiler.enable

  Sidekiq.logger.info "Loaded rufus scheduler"

  scheduler = Rufus::Scheduler.start_new

  scheduler.every "15s" do
    ParseTradeChat.perform_async
  end

  scheduler.cron "*/5 * * * *" do
    SyncGameData.perform_async
    ProcessStats.perform_async
  end

  scheduler.cron "*/10 * * * *" do
    CacheStoreTotals.perform_async
  end

  scheduler.every "30s" do
    Sidekiq.logger.info "Queued CalculatePrices (1 hour)"
    CalculatePrices.perform_async("h1", 1.hour)
  end

  scheduler.cron "*/30 * * * *" do
    Sidekiq.logger.info "Queued CalculatePrices (24 hours)"
    CalculatePrices.perform_async("d1", 24.hours)
  end

  scheduler.cron "0 */1 * * *" do
    Sidekiq.logger.info "Queued CalculatePrices (3 days)"
    CalculatePrices.perform_async("d3", 3.days)

    Sidekiq.logger.info "Queued LogPriceGraph (hourly)"
    LogPriceGraph.perform_async(CardPriceGraph::HOURLY)
  end

  scheduler.cron "0 */3 * * *" do
    Sidekiq.logger.info "Queued CalculatePrices (7 days)"
    CalculatePrices.perform_async("d7", 7.days)
  end

  scheduler.cron "0 */6 * * *" do
    Sidekiq.logger.info "Queued CalculatePrices (14 days)"
    CalculatePrices.perform_async("d14", 14.days)
  end

  scheduler.cron "0 */12 * * *" do
    Sidekiq.logger.info "Queued CalculatePrices (30 days)"
    CalculatePrices.perform_async("d30", 30.days)
  end

  scheduler.cron "0 0 * * *" do
    Sidekiq.logger.info "Queued LogPriceGraph (daily)"
    LogPriceGraph.perform_async(CardPriceGraph::DAILY)
  end

  scheduler.in "1s" do
    ParseTradeChat.perform_async
  end
end