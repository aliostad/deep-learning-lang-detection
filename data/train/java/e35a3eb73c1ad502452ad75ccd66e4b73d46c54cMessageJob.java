package org.rhok.txt4g.execution;

import org.rhok.txt4g.service.FeedRepository;
import org.rhok.txt4g.service.NewsItemRepository;

public abstract class MessageJob implements Runnable {
	protected FeedRepository feedRepository;
	protected NewsItemRepository newsItemRepository;	
	
	public FeedRepository getFeedRepository() {
		return feedRepository;
	}

	public void setFeedRepository(FeedRepository feedRepository) {
		this.feedRepository = feedRepository;
	}

	public NewsItemRepository getNewsItemRepository() {
		return newsItemRepository;
	}

	public void setNewsItemRepository(NewsItemRepository newsItemRepository) {
		this.newsItemRepository = newsItemRepository;
	}
}