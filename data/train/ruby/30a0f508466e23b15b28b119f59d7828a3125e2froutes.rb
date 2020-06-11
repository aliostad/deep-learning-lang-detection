module Routes
  def self.routes
    tweet_handler = TweetHandler.new
    user_handler  = UserHandler.new

    Resty.build do
      tweets do
        route    :tweets
        params   %w(user_id post)
        handlers do
          get_all tweet_handler.get_tweets
          post    tweet_handler.create_tweet
          get     tweet_handler.get_tweet
          put     tweet_handler.update_tweet
          delete  tweet_handler.delete_tweet
        end
      end

      users do
        route    :users
        params   %w(name)
        handlers do
          get_all user_handler.get_users
          post    user_handler.create_user
          get     user_handler.get_user
          put     user_handler.update_user
          delete  user_handler.delete_user
        end
      end
    end
  end
end
