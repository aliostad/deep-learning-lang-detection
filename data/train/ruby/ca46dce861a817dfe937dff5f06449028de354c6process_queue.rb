class ProcessQueue
  @queue = :gource_tv_queue

  def initialize(repository)
    @repository = repository
    @retry = false
  end

  def process!
    with_video do
      upload!(5)
    end

    @repository.process_video if @retry
  end

  def self.perform(repository_hash)
    self.new(Repository.find(repository_hash['id'])).process!
  end

  private

  def with_repository
    @repository.clone_from_github

    yield

    @repository.remove_from_filesystem
  end

  def with_video
    with_repository do
      GourceRunner.new(@repository).run!

      yield

      File.delete(@repository.video_path)
    end
  end

  def upload!(retries)
    begin
      video = VideoManager.new(@repository).upload!
      @repository.update_attributes(youtube_id: video.id, processing: false)
    end
  end
end
