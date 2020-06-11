class UpdateRepositoryCommand < Command

  def initialize(repository, repository_params, doing_user, remote_ip)
    @repository = repository
    @repository_params = repository_params
    @doing_user = doing_user
    @remote_ip = remote_ip
  end

  def execute
    begin
      @repository.update!(@repository_params)
    rescue ActiveRecord::RecordInvalid
      @repository.events << Event.create(
          description: "Attempted to update repository "\
          "\"#{@repository.name},\" but failed: "\
          "#{@repository.errors.full_messages[0]}",
          user: @doing_user, address: @remote_ip,
          event_level: EventLevel::DEBUG)
      raise ValidationError,
            "Failed to update repository \"#{@repository.name}\": "\
            "#{@repository.errors.full_messages[0]}"
    rescue => e
      @repository.events << Event.create(
          description: "Attempted to update repository "\
          "\"#{@repository.name},\" but failed: #{e.message}",
          user: @doing_user, address: @remote_ip,
          event_level: EventLevel::ERROR)
      raise "Failed to update repository \"#{@repository.name}\": #{e.message}"
    else
      @repository.events << Event.create(
          description: "Updated repository \"#{@repository.name}\" in "\
          "institution \"#{@repository.institution.name}\"",
          user: @doing_user, address: @remote_ip)
    end
  end

  def object
    @repository
  end

end
