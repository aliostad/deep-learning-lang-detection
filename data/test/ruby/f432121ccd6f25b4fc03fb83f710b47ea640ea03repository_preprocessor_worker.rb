class RepositoryPreprocessorWorker
  include Sidekiq::Worker

  # @param [int] repository_id:
  def perform(repository_id)
    repository = Repository.find(repository_id)
    channel = WebsocketChannel.find(:repository_processing, repository_id)

    tracker = ProgressTracker.new
    tracker.on_update do
      channel.trigger(:updated, progress: tracker.ratio, done: false)
    end

    # Clone or pull the repo, estimated cost 1%
    tracker.run 1 do
      GitUtils.sync(repository)
    end

    # Sync the revision, estimated cost 1%
    tracker.run 1 do
      repository.sync_revisions
    end

    #Sync the pages, estimated cost 1%
    tracker.run 1 do
      repository.sync_pages
    end

    tracker.sub 97 do |sub_tracker|
      handler = PagePreviewHandler.new(repository)
      #Take the screenshots
      page_to_render = handler.page_to_render
      handler.on :page_rendered do
        sub_tracker.update(100.to_f/page_to_render)
      end
      handler.compute_all
      handler.close
    end
    repository.reload
    repository.processing = nil
    repository.save
    channel.trigger(:updated, progress: 1, done: true)
  end
end

