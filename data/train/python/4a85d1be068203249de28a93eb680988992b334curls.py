#encoding:utf-8

urls = (
        #----------------- mobile -----------------
        '/',                "controller.mobile.index",
        '/a/(\d+)/?',       "controller.mobile.article",
        '/c/(\d+)/?',       "controller.mobile.category",
        
        '/login',           "controller.mobile.login",
        '/logout',          "controller.mobile.logout",
        '/register',        "controller.mobile.register",
        '/find_password',   "controller.mobile.find_password",
        #-----------------/ mobile -----------------
        
        #----------------- controller.admin -------------------
        "/admin/?",         "controller.admin.index",
        "/admin/login/?",   "controller.admin.login",
        "/admin/logout/?",  "controller.admin.logout",
        
        
        "/admin/user_list",            "controller.admin.user.user_list",
        "/admin/user_read/(\d+)",      "controller.admin.user.user_read",
        "/admin/user_edit/(\d+)",      "controller.admin.user.user_edit",
        "/admin/user_delete/(\d+)",    "controller.admin.user.user_delete",
        
        "/admin/insp_type_list",            "controller.admin.insp_type.insp_type_list",
        "/admin/insp_type_read/(\d+)",      "controller.admin.insp_type.insp_type_read",
        "/admin/insp_type_edit/(\d+)",      "controller.admin.insp_type.insp_type_edit",
        "/admin/insp_type_delete/(\d+)",    "controller.admin.insp_type.insp_type_delete",
        
        "/admin/insp_item_list",            "controller.admin.insp_item.insp_item_list",
        "/admin/insp_item_read/(\d+)",      "controller.admin.insp_item.insp_item_read",
        "/admin/insp_item_edit/(\d+)",      "controller.admin.insp_item.insp_item_edit",
        "/admin/insp_item_delete/(\d+)",    "controller.admin.insp_item.insp_item_delete",
        
        "/admin/insp_plan_list",            "controller.admin.insp_plan.insp_plan_list",
        "/admin/insp_plan_read/(\d+)",      "controller.admin.insp_plan.insp_plan_read",
        "/admin/insp_plan_edit/(\d+)",      "controller.admin.insp_plan.insp_plan_edit",
        "/admin/insp_plan_delete/(\d+)",    "controller.admin.insp_plan.insp_plan_delete",
        
        "/admin/insp_value_list",            "controller.admin.insp_value.insp_value_list",
        "/admin/insp_value_read/(\d+)",      "controller.admin.insp_value.insp_value_read",
        "/admin/insp_value_edit/(\d+)",      "controller.admin.insp_value.insp_value_edit",
        "/admin/insp_value_delete/(\d+)",    "controller.admin.insp_value.insp_value_delete",
        
        #-----------------/ controller.admin ------------------
        
)

