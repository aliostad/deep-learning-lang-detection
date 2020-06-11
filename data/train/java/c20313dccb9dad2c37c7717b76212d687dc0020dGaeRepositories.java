package nmd.orb.gae;

import nmd.orb.gae.cache.MemCache;
import nmd.orb.gae.repositories.*;
import nmd.orb.repositories.*;
import nmd.orb.repositories.cached.*;

/**
 * @author : igu
 */
public enum GaeRepositories {

    INSTANCE;

    private final FeedUpdateTaskSchedulerContextRepository feedUpdateTaskSchedulerContextRepository = new CachedFeedUpdateTaskSchedulerContextRepository(MemCache.INSTANCE);
    private final FeedItemsRepository feedItemsRepository = new CachedFeedItemsRepository(GaeFeedItemsRepository.INSTANCE, MemCache.INSTANCE);
    private final FeedUpdateTaskRepository feedUpdateTaskRepository = new CachedFeedUpdateTaskRepository(GaeFeedUpdateTaskRepository.INSTANCE, MemCache.INSTANCE);
    private final FeedHeadersRepository feedHeadersRepository = new CachedFeedHeadersRepository(GaeFeedHeadersRepository.INSTANCE, MemCache.INSTANCE);
    private final ReadFeedItemsRepository readFeedItemsRepository = GaeReadFeedItemsRepository.INSTANCE;
    private final CategoriesRepository categoriesRepository = new CachedCategoriesRepository(GaeCategoriesRepository.INSTANCE, MemCache.INSTANCE);
    private final UpdateErrorsRepository updateErrorsRepository = new CachedUpdateErrorsRepository(MemCache.INSTANCE);

    public FeedUpdateTaskSchedulerContextRepository getFeedUpdateTaskSchedulerContextRepository() {
        return this.feedUpdateTaskSchedulerContextRepository;
    }

    public FeedItemsRepository getFeedItemsRepository() {
        return this.feedItemsRepository;
    }

    public FeedUpdateTaskRepository getFeedUpdateTaskRepository() {
        return this.feedUpdateTaskRepository;
    }

    public FeedHeadersRepository getFeedHeadersRepository() {
        return this.feedHeadersRepository;
    }

    public ReadFeedItemsRepository getReadFeedItemsRepository() {
        return this.readFeedItemsRepository;
    }

    public CategoriesRepository getCategoriesRepository() {
        return this.categoriesRepository;
    }

    public UpdateErrorsRepository getUpdateErrorsRepository() {
        return this.updateErrorsRepository;
    }

}
