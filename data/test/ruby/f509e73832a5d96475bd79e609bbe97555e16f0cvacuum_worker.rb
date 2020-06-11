class VacuumWorker
  include Sidekiq::Worker

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/vacuum.log")
  end

  def perform(repository_id)
    begin
      raise "No id for repository" if repository_id.blank?

      repository = Repository.find(repository_id)
      raise "No repository" if repository.blank?

      logger.info "Beginning of loot #{repository.link}"
      link_sanitizer = Vacuum::LinkSanitizer.new(repository.link)
      loot_place = Vacuum::LootPlace.new(root_link: link_sanitizer, link: link_sanitizer, repository: repository)

      loot_place.sack_it!

      logger.info "END of loot #{repository.link}"
    rescue => e
      logger.error "Unable to loot repository: #{e}"
    end

    logger.info "===="
  end
end
