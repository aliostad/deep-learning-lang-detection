#{%block imports%}
from Controllers import BaseControllers
from Controllers import ShellControllers
from Controllers import HalWebControllers
#{%endblock%}
webapphandlers = [
#{%block ApplicationControllers %}


#{%block BaseControllers %}
('/Login', BaseControllers.LoginController),
('/Login/(.*)', BaseControllers.LoginController),
('/Logout',BaseControllers.LogoutController),
('/AddUser', BaseControllers.AddUserController),
('/WishList', BaseControllers.WishListController),
('/admin/Role', BaseControllers.RoleController),
('/admin/RoleAssociation', BaseControllers.RoleAssociationController),
('/Base/WishList', BaseControllers.WishListController),
('/Base/Invitation', BaseControllers.InvitationController),
#{%endblock%}

#{%block ShellControllers%}
('/admin/Shell', ShellControllers.FrontPageController),
('/admin/stat.do', ShellControllers.StatementController),
#{%endblock%}

#{%block HalWebControllers%}
('/', HalWebControllers.WelcomeController),
#{%endblock%}

#{%endblock%}
]

