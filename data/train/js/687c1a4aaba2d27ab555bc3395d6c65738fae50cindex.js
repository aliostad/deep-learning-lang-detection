/** attach controllers to this module 
 * if you get 'unknown {x}Provider' errors from angular, be sure they are
 * properly referenced in one of the module dependencies in the array.
 * below, you can see we bring in our services and constants modules 
 * which avails each controller of, for example, the `config` constants object.
 **/
define([
    './footer-controller',
    './header-controller',
    './primary-controller',
  
    './about/about-controller',
    './admin/admin-controller',
    
    './campaign/campaign-controller',
    './campaign/mycampaigns/mycampaigns-controller',
    './campaign/newcampaign/newcampaign-controller',
    './campaign/requests/campaignrequests-controller',
    './campaign/search/searchcampaigns-controller',
    
    './flagged/flagged-controller',
    
    './funds/funds-controller',
    
    './help/help-controller',
    
    './home/home-controller',
    
    './jobs/jobs-controller',
   
    './login/forgotpassword-controller',
    './login/login-controller',
    './login/recoverpassword-controller',
    
    './logout/logout-controller',
    
    './messages/messages-controller',
    
    './notifications/notifications-controller',
    
    './overview/overview-controller',
    
    './profile/edit-profile-controller',
    './profile/profile-controller',
    
    './registration/activateregistration-controller',
    './registration/confirmregistration-controller',
    './registration/register-controller',

    './reporting/reporting-controller',
    
    './settings/settings-controller',
    
    './terms/terms-controller',
    
    './tools/tools-controller',
     
    './users/findadvertisers-controller',
    './users/findpublishers-controller',
    './users/foundadvertisers-controller',
    './users/foundpublishers-controller',
    './users/users-controller'


], function () {});
