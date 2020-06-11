post '/fetch_tweets' do

	@handler = TwitterUser.format_handler(params[:handler])

	if TwitterUser.exists?(@handler)
		@handler = TwitterUser.find_by_handler(@handler)
		if Tweet.tweets_stale?(@handler)
			@tweets = @handler.tweets.all
			@tweets.destroy_all
			@tweets = Tweet.fetch_recent_tweets(@handler.handler)
			@tweets.each do |tweet|
				Tweet.create(tweet: tweet, twitter_user_id: @handler.id)
			end
			@tweets = @handler.tweets
		else
			@tweets = @handler.tweets
		end
	else
		@handler = TwitterUser.create(handler: @handler)
		@tweets = Tweet.fetch_recent_tweets(@handler.handler)
		@tweets.each do |tweet|
			Tweet.create(tweet: tweet, twitter_user_id: @handler.id)
		end
		@tweets = @handler.tweets	
	end
	erb :index
end

get '/:handler' do

	@handler = TwitterUser.format_handler(params[:handler])

	if TwitterUser.exists?(@handler)
		@handler = TwitterUser.find_by_handler(@handler)
		if Tweet.tweets_stale?(@handler)
			@tweets = @handler.tweets.all
			@tweets.destroy_all
			@tweets = Tweet.fetch_recent_tweets(@handler.handler)
			@tweets.each do |tweet|
				Tweet.create(tweet: tweet, twitter_user_id: @handler.id)
			end
			@tweets = @handler.tweets
		else
			@tweets = @handler.tweets
		end
	else
		@handler = TwitterUser.create(handler: @handler)
		@tweets = Tweet.fetch_recent_tweets(@handler.handler)
		@tweets.each do |tweet|
			Tweet.create(tweet: tweet, twitter_user_id: @handler.id)
		end
		@tweets = @handler.tweets	
	end
	erb :index
end