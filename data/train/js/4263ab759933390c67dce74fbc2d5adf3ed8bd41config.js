/**
 * Created by Mazhar on 10/2/2014.
 */


var host = 'http://localhost:11827/'; // change with your site name
/*
 *  Cms structure url
 */
cms_url = new Array();

cms_url['get_cms_url'] = host + 'selfcare-panel/';

logoutUrl = host + 'cmsPanel/';

/*CONFIGURATION */
service_host = host + 'WebFramework/'; // zubayer

service_url = new Array();
service_url['get_category_url'] = service_host + 'CMSWebService/getCMSCategoryList.php';
service_url['new_category_url'] = service_host + 'CMSWebService/newCMSCategory.php';
service_url['delete_category_by_id_url'] = service_host + 'CMSWebService/deleteCMSCategory.php';

service_url['get_content_url'] = service_host + 'CMSWebService/getCMSContentList.php';
service_url['new_content_url'] = service_host + 'CMSWebService/newCMSContent.php';
service_url['delete_content_url'] = service_host + 'CMSWebService/deleteCMSContent.php';

service_url['get_header_footer'] = service_host + 'CMSWebService/getHeaderFooter.php';
service_url['edit_header_footer'] = service_host + 'CMSWebService/editHeaderFooter.php';

//cms User sevices //zubayer
service_url['login'] = service_host + 'CMSWebService/login.php';

service_url['add_user'] = service_host + 'CMSWebService/newCMSUser.php';
service_url['edit_user'] = service_host + 'CMSWebService/editCMSUser.php';
service_url['get_user'] = service_host + 'CMSWebService/getCMSUser.php';
service_url['delete_user'] = service_host + 'CMSWebService/deleteCMSUser.php';


service_url['get_permission_list'] = service_host + 'CMSWebService/getCMSPermissionList.php';
service_url['get_user_permission_list'] = service_host + 'CMSWebService/getCMSUserPermissionList.php';

