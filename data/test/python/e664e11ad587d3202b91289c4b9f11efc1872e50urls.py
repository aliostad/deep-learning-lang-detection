# django imports
from django.conf.urls.defaults import *

# LFC Manage
urlpatterns = patterns('lfc.manage.views',

    # applications
    url(r'^applications$', "applications", name="lfc_applications"),
    url(r'^install-application/(?P<name>\w+)$', "install_application", name="lfc_install_application"),
    url(r'^uninstall-application/(?P<name>\w+)$', "uninstall_application", name="lfc_uninstall_application"),
    url(r'^reinstall-application/(?P<name>\w+)$', "reinstall_application", name="lfc_reinstall_application"),

    # cut'n paste
    url(r'^copy/(?P<id>\d+)$', "lfc_copy", name="lfc_copy"),
    url(r'^cut/(?P<id>\d+)$', "cut", name="lfc_cut"),
    url(r'^paste/(?P<id>\d+)$', "paste", name="lfc_paste"),
    url(r'^paste$', "paste", name="lfc_paste"),

    # content types
    url(r'^content-types$', "content_types", name="lfc_content_types"),
    url(r'^content-type/(?P<id>\d+)$', "content_type", name="lfc_content_type"),

    # filebrowser
    url(r'^imagebrowser$', "imagebrowser", name="lfc_imagebrowser"),
    url(r'^filebrowser$', "filebrowser", name="lfc_filebrowser"),
    url(r'^fb-upload-image$', "fb_upload_image", name="lfc_fb_upload_image"),
    url(r'^fb-upload-file$', "fb_upload_file", name="lfc_fb_upload_file"),

    # manage content
    url(r'^add-object/(?P<id>\w+)$', "add_object", name="lfc_add_object"),
    url(r'^add-object$', "add_object", name="lfc_add_top_object"),
    url(r'^add-object/(?P<language>\w+)/(?P<id>\w+)$', "add_object", name="lfc_add_object"),
    url(r'^delete-object/(?P<id>\d+)$', "delete_object", name="lfc_delete_object"),
    url(r'^save-core-data/(?P<id>\d+)$', "object_core_data", name="lfc_save_object_core_data"),
    url(r'^save-meta-data/(?P<id>\d+)$', "object_meta_data", name="lfc_save_meta_data"),
    url(r'^save-seo/(?P<id>\d+)$', "object_seo_data", name="lfc_save_seo"),

    # images
    url(r'^load-object-images/(?P<id>\d+)$', "load_object_images", name="lfc_load_object_images"),
    url(r'^add-images/(?P<id>\d+)$', "add_object_images", name="lfc_add_images"),
    url(r'^update-images/(?P<id>\d+)$', "update_object_images", name="lfc_update_images"),
    url(r'^edit-image/(?P<id>\d+)$', "edit_image", name="lfc_edit_image"),
    url(r'^move-image/(?P<id>\d+)$', "move_image", name="lfc_move_image"),

    url(r'^load-portal-images$', "load_portal_images", name="lfc_load_portal_images"),
    url(r'^add-portal-images$', "add_portal_images", name="lfc_add_portal_images"),
    url(r'^update-portal-images$', "update_portal_images", name="lfc_update_portal_images"),

    # files
    url(r'^load-object-files/(?P<id>\d+)$', "load_object_files", name="lfc_load_object_files"),
    url(r'^add-object-files/(?P<id>\d+)$', "add_object_files", name="lfc_add_files"),
    url(r'^update-object-files/(?P<id>\d+)$', "update_object_files", name="lfc_update_files"),

    url(r'^load-portal-files$', "load_portal_files", name="lfc_load_portal_files"),
    url(r'^add-portal-files$', "add_portal_files", name="lfc_add_portal_files"),
    url(r'^update-portal-files$', "update_portal_files", name="lfc_update_portal_files"),
    url(r'^edit-file/(?P<id>\d+)$', "edit_file", name="lfc_edit_file"),
    url(r'^move-file/(?P<id>\d+)$', "move_file", name="lfc_move_file"),

    # comments
    url(r'^update-comments/(?P<id>\d+)$', "update_comments", name="lfc_update_comments"),
    url(r'^edit-comment/(?P<id>\d+)$', "edit_comment", name="lfc_edit_comment"),

    # children
    url(r'^update-children/(?P<id>\d+)$', "update_object_children", name="lfc_update_object_children"),
    url(r'^update-portal-children$', "update_portal_children", name="lfc_update_portal_children"),

    # permissions
    url(r'^load-object-permissions/(?P<id>\d+)$', "load_object_permissions", name="lfc_load_update_object_permissions"),
    url(r'^update-object-permissions/(?P<id>\d+)$', "update_object_permissions", name="lfc_update_object_permissions"),
    url(r'^update-portal-permissions$', "update_portal_permissions", name="lfc_update_portal_permissions"),

    # workflows
    url(r'^do-transition/(?P<id>\d+)$', "do_transition", name="lfc_manage_do_transition"),
    url(r'^workflow/(?P<id>\d+)$', "manage_workflow", name="lfc_manage_workflow"),
    url(r'^workflow$', "manage_workflow", name="lfc_manage_workflow"),
    url(r'^add-workflow$', "add_workflow", name="lfc_manage_add_workflow"),
    url(r'^delete-workflow/(?P<id>\d+)$', "delete_workflow", name="lfc_manage_delete_workflow"),
    url(r'^state/(?P<id>\d+)$', "manage_state", name="lfc_manage_state"),
    url(r'^transition/(?P<id>\d+)$', "manage_transition", name="lfc_manage_transition"),
    url(r'^save-workflow-data/(?P<id>\d+)$', "save_workflow_data", name="lfc_manage_save_workflow_data"),
    url(r'^save-state/(?P<id>\d+)$', "save_workflow_state", name="lfc_manage_save_workflow_state"),
    url(r'^delete-state/(?P<id>\d+)$', "delete_workflow_state", name="lfc_manage_delete_workflow_state"),
    url(r'^add-state/(?P<id>\d+)$', "add_workflow_state", name="lfc_manage_add_workflow_state"),
    url(r'^add-transition/(?P<id>\d+)$', "add_workflow_transition", name="lfc_manage_add_workflow_transition"),
    url(r'^delete-transition/(?P<id>\d+)$', "delete_workflow_transition", name="lfc_manage_delete_workflow_transition"),
    
    url(r'^save-transition/(?P<id>\d+)$', "save_workflow_transition", name="lfc_manage_save_workflow_transition"),

    url(r'^save-portal-core$', "portal_core", name="lfc_save_portal_core"),

    # portlets
    url(r'^add-portlet/(?P<object_type_id>\d+)/(?P<object_id>\d+)$', "add_portlet", name="lfc_add_portlet"),
    url(r'^update-portlets-blocking/(?P<object_type_id>\d+)/(?P<object_id>\d+)$', "update_portlets_blocking", name="lfc_update_portlets_blocking"),
    url(r'^delete-portlet/(?P<portletassignment_id>\d+)$', "delete_portlet", name="lfc_delete_portlet"),
    url(r'^edit-portlet/(?P<portletassignment_id>\d+)$', "edit_portlet", name="lfc_edit_portlet"),
    url(r'^move-portlet/(?P<portletassignment_id>\d+)$', "move_portlet", name="lfc_move_portlet"),

    url(r'^review$', "review_objects", name="lfc_manage_review"),

    # local roles
    url(r'^save-local-roles/(?P<id>\d+)', "save_local_roles", name="lfc_manage_save_local_roles"),
    url(r'^local-roles-add-form/(?P<id>\d+)', "local_roles_add_form", name="lfc_manage_local_roles_add_form"),
    url(r'^local-roles-search/(?P<id>\d+)', "local_roles_search", name="lfc_manage_local_roles_search"),
    url(r'^add-local-roles/(?P<id>\d+)', "add_local_roles", name="lfc_manage_add_local_roles"),

    # translation
    url(r'^save-translation', "save_translation", name="lfc_save_translation"),
    url(r'^(?P<id>\d+)/translate/(?P<language>\w{2})', "translate_object", name="lfc_translate_object"),

    # navigation
    url(r'^set-navigation-tree-language/(?P<language>\w{2})', "set_navigation_tree_language", name="lfc_set_navigation_tree_language"),
    url(r'^set-language/(?P<language>\w{2})', "set_language", name="lfc_manage_set_language"),
    url(r'^set-template$', "set_template", name="lfc_set_template"),

    # users
    url(r'^users', "manage_users", name="lfc_manage_users"),
    url(r'^user/(?P<id>\d+)', "manage_user", name="lfc_manage_user"),
    url(r'^user$', "manage_user", name="lfc_manage_user"),
    url(r'^save-user-data/(?P<id>\d+)', "save_user_data", name="lfc_save_user_data"),
    url(r'^add-user', "add_user", name="lfc_add_user"),
    url(r'^delete-user/(?P<id>\d+)', "delete_user", name="lfc_delete_user"),
    url(r'^change-users', "change_users", name="lfc_manage_change_users"),
    url(r'^change-password/(?P<id>\d+)', "change_password", name="lfc_manage_change_password"),
    url(r'^set-users-filter', "set_users_filter", name="lfc_manage_set_users_filter"),
    url(r'^reset-users-filter', "reset_users_filter", name="lfc_manage_reset_users_filter"),
    url(r'^set-users-page', "set_users_page", name="lfc_manage_set_users_page"),
    url(r'^set-user-filter', "set_user_filter", name="lfc_manage_set_user_filter"),
    url(r'^reset-user-filter', "reset_user_filter", name="lfc_manage_reset_user_filter"),
    url(r'^set-user-page', "set_user_page", name="lfc_manage_set_user_page"),

    # groups
    url(r'^group$', "manage_group", name="lfc_manage_group"),
    url(r'^group/(?P<id>\d+)$', "manage_group", name="lfc_manage_group"),
    url(r'^add-group$', "add_group", name="lfc_manage_add_group"),
    url(r'^save-group/(?P<id>\d+)$', "save_group", name="lfc_manage_save_group"),
    url(r'^delete-group/(?P<id>\d+)$', "delete_group", name="lfc_manage_delete_group"),

    # roles
    url(r'^role$', "manage_role", name="lfc_manage_role"),
    url(r'^role/(?P<id>\d+)$', "manage_role", name="lfc_manage_role"),
    url(r'^add-role$', "add_role", name="lfc_manage_add_role"),
    url(r'^save-role/(?P<id>\d+)$', "save_role", name="lfc_manage_save_role"),
    url(r'^delete-role/(?P<id>\d+)$', "delete_role", name="lfc_manage_delete_role"),

    # content
    url(r'^portal', "portal", name="lfc_manage_portal"),
    url(r'^(?P<id>\d+)$', "manage_object", name="lfc_manage_object"),
    url(r'^load-object-parts/(?P<id>\d+)$', "load_object_parts", name="lfc_load_object_parts"),
    url(r'^load-object/(?P<id>\d+)$', "load_object", name="lfc_load_object"),
    url(r'^load-portal$', "load_portal", name="lfc_load_portal"),
    url(r'^/#page=(?P<id>\d+)$', "load_object", name="lfc_load_object"),
)
