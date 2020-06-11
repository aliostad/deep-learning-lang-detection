class VideoManager
  def initialize(repository)
    @repository = repository
  end

  def upload!
    client.upload_video(File.open(@repository.video_path), settings)
  end

  def processing?
    begin
      remote_video = Yt::Video.new(id: @repository.youtube_id, auth: client)
      remote_video.present? && !remote_video.processed?
    rescue
      true
    end
  end

  private

  def client
    @client ||= Yt::Account.new(refresh_token: ENV['YOUTUBE_REFRESH_TOKEN'])
  end

  def settings
    { title: "#{@repository.account} - #{@repository.name}",
      description: "Visualization of #{@repository.web_url}",
      keywords: [:gource, @repository.account, @repository.name] }
  end
end
