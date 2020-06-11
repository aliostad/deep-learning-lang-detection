module Aji
  class Queues::BackgroundYoutubeRequest
    extend Queues::WithDatabaseConnection

    @queue = :background_youtube_request

    def self.perform api_info, api_method, *args
      api = YoutubeAPI.new api_info['uid'], api_info['token'],
        api_info['secret']

      # If we're throttled, wait ten seconds, then try again.
      if api.post_tracker.available? :post
        api.send api_method, *args
      else
        Resque.enqueue_in_front self, api_info, api_method, *args
        sleep 10
      end

    rescue AuthenticationError, UploadError => e
      if e.message =~ /too_many_recent_calls/
        Resque.enqueue_in_front self, api_info, api_method, *args
        api.post_tracker.close_session!(
          "#{api_info[:uid]}:#{api_method}:#{args * ","} => #{e.inspect}")
      end
    end
  end
end

