package at.knowcenter.recommender.solrpowered.services;

import at.knowcenter.recommender.solrpowered.configuration.ConfigUtils;
import at.knowcenter.recommender.solrpowered.services.impl.actions.RecommendService;
import at.knowcenter.recommender.solrpowered.services.impl.item.ItemService;
import at.knowcenter.recommender.solrpowered.services.impl.positionnetwork.PositionNetworkService;
import at.knowcenter.recommender.solrpowered.services.impl.positions.PositionService;
import at.knowcenter.recommender.solrpowered.services.impl.resource.ResourceService;
import at.knowcenter.recommender.solrpowered.services.impl.review.ReviewService;
import at.knowcenter.recommender.solrpowered.services.impl.sharedlocation.SharedLocationService;
import at.knowcenter.recommender.solrpowered.services.impl.social.SocialActionService;
import at.knowcenter.recommender.solrpowered.services.impl.social.reversed.OwnSocialActionService;
import at.knowcenter.recommender.solrpowered.services.impl.socialstream.SocialStreamService;
import at.knowcenter.recommender.solrpowered.services.impl.user.UserService;

/**
 * Contains all services which access SOLR.
 * <br/>
 * Used as a container to get needed services without the need to manually configure them
 * @author elacic
 *
 */
public class SolrServiceContainer {
	
	// Main services in leave one out method or either for training set
	private RecommendService recommendService;
	private UserService userService;
	private ItemService itemService;
	private SocialActionService socialActionService;
	private OwnSocialActionService ownSocialActionService;
	private SocialStreamService socialStreamService;
	private ResourceService resourceService;
	private ReviewService reviewService;
	private PositionService positionService;
	private PositionNetworkService positionNetworkService;
	private SharedLocationService sharedLocationService;
	
	// Test services
	
	private ResourceService testResourceService;
	private ReviewService testReviewService;

	
	/**
	 * Initialization-on-demand holder idiom
	 * <br/>
	 * {@link http://en.wikipedia.org/wiki/Initialization-on-demand_holder_idiom}
	 * @author elacic
	 *
	 */
	private static class Holder {
        static final SolrServiceContainer INSTANCE = new SolrServiceContainer();
    }
	
	public static SolrServiceContainer getInstance() {
        return Holder.INSTANCE;
    }
	
	private SolrServiceContainer() {
	    ConfigUtils.loadConfiguration();
	    boolean success = init();
	    if (! success){
	    	throw new RuntimeException("All Solr services, as defined in the configuration, could not be initialized!");
	    }
	}
	
	
	private boolean init() {
		boolean initSuccess = false;
		
		int port = 8984;
		String address = "kti-social";
		
		try {
			UserService userService = new UserService(address, port, "profiles");
			RecommendService recommenderService = new RecommendService(address, port, "collection2");
			ItemService itemService = new ItemService(address, port, "collection1");
			SocialActionService socialService = new SocialActionService(address, port, "social_action_pruned");
			OwnSocialActionService ownSocialService = new OwnSocialActionService(address, port, "own_social_action");
			SocialStreamService socialStreamService = new SocialStreamService(address, port, "social_stream");
			ResourceService resourceService = new ResourceService(address, port, "resources");
			ReviewService reviewService = new ReviewService(address, port, "reviews");
			PositionService positionService = new PositionService(address, port, "positions");
			PositionNetworkService positionNetworkService = new PositionNetworkService(address, port, "position_network");
			SharedLocationService sharedLocationService = new SharedLocationService(address, port, "shared_locations");

			setUserService(userService);
			setRecommendService(recommenderService);
			setItemService(itemService);
			setSocialActionService(socialService);
			setOwnSocialActionService(ownSocialService);
			setSocialStreamService(socialStreamService);
			setResourceService(resourceService);
			setReviewService(reviewService);
			setPositionService(positionService);
			setPositionNetworkService(positionNetworkService);
			setSharedLocationService(sharedLocationService);

			int testPort = 8989;
			
			ResourceService testResourceService = new ResourceService(address, testPort, "resources");
			ReviewService testReviewService = new ReviewService(address, testPort, "reviews");

			setTestResourceService(testResourceService);
			setTestReviewService(testReviewService);

			initSuccess = true;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return initSuccess;
	}

	public RecommendService getRecommendService() {
		return recommendService;
	}

	public void setRecommendService(RecommendService recommendService) {
		this.recommendService = recommendService;
	}

	public UserService getUserService() {
		return userService;
	}

	public ItemService getItemService() {
		return itemService;
	}

	public void setItemService(ItemService searchService) {
		this.itemService = searchService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	public SocialActionService getSocialActionService() {
		return socialActionService;
	}

	public void setSocialActionService(SocialActionService socialActionService) {
		this.socialActionService = socialActionService;
	}

	public OwnSocialActionService getOwnSocialActionService() {
		return ownSocialActionService;
	}

	public void setOwnSocialActionService(OwnSocialActionService ownSocialActionService) {
		this.ownSocialActionService = ownSocialActionService;
	}

	public SocialStreamService getSocialStreamService() {
		return socialStreamService;
	}

	public void setSocialStreamService(SocialStreamService socialStreamService) {
		this.socialStreamService = socialStreamService;
	}

	public ResourceService getResourceService() {
		return resourceService;
	}

	public void setResourceService(ResourceService resourceService) {
		this.resourceService = resourceService;
	}

	public ReviewService getReviewService() {
		return reviewService;
	}

	public void setReviewService(ReviewService reviewService) {
		this.reviewService = reviewService;
	}

	public PositionService getPositionService() {
		return positionService;
	}

	public void setPositionService(PositionService positionService) {
		this.positionService = positionService;
	}

	public PositionNetworkService getPositionNetworkService() {
		return positionNetworkService;
	}

	public void setPositionNetworkService(
			PositionNetworkService positionNetworkService) {
		this.positionNetworkService = positionNetworkService;
	}

	public SharedLocationService getSharedLocationService() {
		return sharedLocationService;
	}

	public void setSharedLocationService(SharedLocationService sharedLocationService) {
		this.sharedLocationService = sharedLocationService;
	}

	public ResourceService getTestResourceService() {
		return testResourceService;
	}

	public void setTestResourceService(ResourceService testResourceService) {
		this.testResourceService = testResourceService;
	}

	public ReviewService getTestReviewService() {
		return testReviewService;
	}

	public void setTestReviewService(ReviewService testReviewService) {
		this.testReviewService = testReviewService;
	}
	
	
}
