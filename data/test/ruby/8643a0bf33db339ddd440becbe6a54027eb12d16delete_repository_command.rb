class DeleteRepositoryCommand < Command

  def initialize(repository, doing_user, remote_ip)
    @repository = repository
    @doing_user = doing_user
    @address = remote_ip
  end

  def execute
    begin
      @repository.destroy!
    rescue ActiveRecord::DeleteRestrictionError => e
      raise e # this should never happen
    rescue => e
      @repository.events << Event.create(
          description: "Attempted to delete repository "\
          "\"#{@repository.name},\" but failed: #{e.message}",
          user: @doing_user, address: @address, event_level: EventLevel::ERROR)
      raise "Failed to delete repository \"#{@repository.name}\": #{e.message}"
    else
      @repository.institution.events << Event.create(
          description: "Deleted repository \"#{@repository.name}\" "\
          "from institution \"#{@repository.institution.name}\"",
          user: @doing_user, address: @address)
    end
  end

  def object
    @repository
  end

end
