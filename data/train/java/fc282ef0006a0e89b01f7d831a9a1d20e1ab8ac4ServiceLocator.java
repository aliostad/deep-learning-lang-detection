package user.management.service.locator;

import user.management.service.api.ContactmethodsService;
import user.management.service.api.PermissionsService;
import user.management.service.api.RecommendationsService;
import user.management.service.api.RelationPermissionsService;
import user.management.service.api.ResetPasswordsService;
import user.management.service.api.RobinsonsService;
import user.management.service.api.RolesService;
import user.management.service.api.RuleViolationsService;
import user.management.service.api.UserCreditsService;
import user.management.service.api.UserDataService;
import user.management.service.api.UserManagementService;
import user.management.service.api.UsersService;

public interface ServiceLocator {


	/**
	 * Gets the contactmethods service.
	 * 
	 * @return the contactmethods service
	 */
	ContactmethodsService getContactmethodsService();

	/**
	 * Gets the permission service.
	 * 
	 * @return the permission service
	 */
	PermissionsService getPermissionService();

	/**
	 * Gets the RecommendationsService.
	 * 
	 * @return the RecommendationsService.
	 */
	RecommendationsService getRecommendationsService();

	/**
	 * Gets the RelationPermissionsService.
	 * 
	 * @return the RelationPermissionsService.
	 */
	RelationPermissionsService getRelationPermissionsService();

	/**
	 * Gets the reset passwords service.
	 * 
	 * @return the reset passwords service
	 */
	ResetPasswordsService getResetPasswordsService();

	/**
	 * Gets the robinsons service.
	 *
	 * @return the robinsons service
	 */
	RobinsonsService getRobinsonsService();

	/**
	 * Gets the roles service.
	 * 
	 * @return the roles service
	 */
	RolesService getRolesService();

	/**
	 * Gets the rule violations service.
	 *
	 * @return the rule violations service
	 */
	RuleViolationsService getRuleViolationsService();
	
	/**
	 * Gets the user credits service.
	 *
	 * @return the user credits service
	 */
	UserCreditsService getUserCreditsService();

	/**
	 * Gets the user data service.
	 *
	 * @return the user data service
	 */
	UserDataService getUserDataService();

	/**
	 * Gets the user management service.
	 * 
	 * @return the user management service
	 */
	UserManagementService getUserManagementService();

	/**
	 * Gets the users service.
	 * 
	 * @return the users service
	 */
	UsersService getUsersService();

	/**
	 * Sets the contactmethods service.
	 * 
	 * @param contactmethodsService
	 *            the new contactmethods service
	 */
	void setContactmethodsService(ContactmethodsService contactmethodsService);

	/**
	 * Sets the permission business service.
	 * 
	 * @param permissionService
	 *            the new permission business service
	 */
	void setPermissionService(PermissionsService permissionService);

	/**
	 * Sets the RecommendationsService.
	 *
	 * @param recommendationsService
	 *            the new RecommendationsService
	 */
	void setRecommendationsService(RecommendationsService recommendationsService);

	/**
	 * Sets the RelationPermissionsService.
	 *
	 * @param relationPermissionsService
	 *            the new RelationPermissionsService
	 */
	void setRelationPermissionsService(
			RelationPermissionsService relationPermissionsService);

	/**
	 * Sets the reset passwords business service.
	 * 
	 * @param resetPasswordsService
	 *            the new reset passwords business service
	 */
	void setResetPasswordsService(ResetPasswordsService resetPasswordsService);

	/**
	 * Sets the robinsons service.
	 *
	 * @param robinsonsService
	 *            the new robinsons service
	 */
	void setRobinsonsService(RobinsonsService robinsonsService);

	/**
	 * Sets the roles service.
	 * 
	 * @param rolesService
	 *            the new roles service
	 */
	void setRolesService(RolesService rolesService);

	/**
	 * Sets the rule violations service.
	 *
	 * @param ruleViolationsService
	 *            the new rule violations service
	 */
	void setRuleViolationsService(RuleViolationsService ruleViolationsService);
	
	/**
	 * Sets the user credits service.
	 *
	 * @param userCreditsService the user credits service
	 */
	void setUserCreditsService(UserCreditsService userCreditsService);

	/**
	 * Sets the user data service.
	 *
	 * @param userDataService
	 *            the user data service
	 */
	void setUserDataService(UserDataService userDataService);

	/**
	 * Sets the user management service.
	 * 
	 * @param userManagementService
	 *            the new user management service
	 */
	void setUserManagementService(UserManagementService userManagementService);

	/**
	 * Sets the users business service.
	 * 
	 * @param usersService
	 *            the new users business service
	 */
	void setUsersService(UsersService usersService);

}
