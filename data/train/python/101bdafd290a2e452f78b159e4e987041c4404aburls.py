#encoding:utf-8
urls = (
'/admin/?',         'controller.admin.index',
'/admin/login',     'controller.admin.login',
'/admin/logout',    'controller.admin.logout',

#--------------user -----------
#----用户信息表----
"/admin/user_list",            "controller.admin.user.user_list",
"/admin/user_read/(\d+)",      "controller.admin.user.user_read",
"/admin/user_edit/(\d+)",      "controller.admin.user.user_edit",
"/admin/user_delete/(\d+)",    "controller.admin.user.user_delete",
#--------------end user -------

#--------------area -----------
#----区域表----
"/admin/area_list",            "controller.admin.area.area_list",
"/admin/area_read/(\d+)",      "controller.admin.area.area_read",
"/admin/area_edit/(\d+)",      "controller.admin.area.area_edit",
"/admin/area_delete/(\d+)",    "controller.admin.area.area_delete",
#--------------end area -------

#--------------policy -----------
#----政策传递----
"/admin/policy_list",            "controller.admin.policy.policy_list",
"/admin/policy_read/(\d+)",      "controller.admin.policy.policy_read",
"/admin/policy_edit/(\d+)",      "controller.admin.policy.policy_edit",
"/admin/policy_delete/(\d+)",    "controller.admin.policy.policy_delete",
#--------------end policy -------



)
