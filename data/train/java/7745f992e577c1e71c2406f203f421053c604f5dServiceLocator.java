package flirt.and.date.hbm.service.locator;

import flirt.and.date.hbm.service.api.FavoriteMembersService;
import flirt.and.date.hbm.service.api.FriendshipRequestsService;
import flirt.and.date.hbm.service.api.ProfileNoticeService;
import flirt.and.date.hbm.service.api.ProfileRatingsService;
import flirt.and.date.hbm.service.api.ProfileVisitorsService;
import flirt.and.date.hbm.service.api.SearchCriteriaService;
import flirt.and.date.hbm.service.api.UserProfileService;

/**
 * The Interface ServiceLocator.
 */
public interface ServiceLocator 
extends 
de.alpharogroup.address.book.business.service.locator.ServiceLocator, 
de.alpharogroup.db.resource.bundles.service.locator.ServiceLocator,
message.system.service.locator.ServiceLocator,
resource.system.service.locator.ServiceLocator,
user.management.service.locator.ServiceLocator
{

	/**
	 * Gets the favorite members service.
	 *
	 * @return the favorite members service
	 */
	FavoriteMembersService getFavoriteMembersService();

	/**
	 * Gets the friendship requests service.
	 *
	 * @return the friendship requests service
	 */
	FriendshipRequestsService getFriendshipRequestsService();

	/**
	 * Gets the profile notice service.
	 *
	 * @return the profile notice service
	 */
	ProfileNoticeService getProfileNoticeService();

	/**
	 * Gets the profile ratings service.
	 *
	 * @return the profile ratings service
	 */
	ProfileRatingsService getProfileRatingsService();
	
	/**
	 * Gets the profile visitors service.
	 *
	 * @return the profile visitors service
	 */
	ProfileVisitorsService getProfileVisitorsService();

	/**
	 * Gets the search criteria service.
	 *
	 * @return the search criteria service
	 */
	SearchCriteriaService getSearchCriteriaService();

	/**
	 * Gets the user profile service.
	 *
	 * @return the user profile service
	 */
	UserProfileService getUserProfileService();

	/**
	 * Sets the favorite members service.
	 *
	 * @param favoriteMembersService the favorite members service
	 */
	void setFavoriteMembersService(FavoriteMembersService favoriteMembersService);

	/**
	 * Sets the friendship requests service.
	 *
	 * @param friendshipRequestsService the friendship requests service
	 */
	void setFriendshipRequestsService(FriendshipRequestsService friendshipRequestsService);
	
	/**
	 * Sets the profile notice service.
	 *
	 * @param profileNoticeService the profile notice service
	 */
	void setProfileNoticeService(ProfileNoticeService profileNoticeService);
	
	/**
	 * Sets the profile ratings service.
	 *
	 * @param profileRatingsService the profile ratings service
	 */
	void setProfileRatingsService(ProfileRatingsService profileRatingsService);
	
	/**
	 * Sets the profile visitors service.
	 *
	 * @param profileVisitorsService the profile visitors service
	 */
	void setProfileVisitorsService(ProfileVisitorsService profileVisitorsService);
	
	/**
	 * Sets the search criteria service.
	 *
	 * @param searchCriteriaService the search criteria service
	 */
	void setSearchCriteriaService(SearchCriteriaService searchCriteriaService);
	
	/**
	 * Sets the user profile business service.
	 * 
	 * @param userProfileService
	 *            the new user profile business service
	 */
	void setUserProfileService(UserProfileService userProfileService );

}
