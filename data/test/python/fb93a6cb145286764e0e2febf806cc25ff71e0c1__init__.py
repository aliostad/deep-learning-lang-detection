#-*-coding:utf-8-*-

"""
路由表的配置
"""

import homecontroller
import logincontroller
import projectconfig
import managercontroller
import postcontroller
import bdeditorcontroller
import postviwercontroller

#route table 
#the mapping between the URL and the URL-Handler



routes_table=[
		(r'/',homecontroller.HomeHandler),
		(r'/account/login',logincontroller.LoginHandler),
		(r'/manage/post',postcontroller.WritePost),
		(r'/manage/editor',bdeditorcontroller.EditorHandler),
		(r'/manage',managercontroller.ManageHandler),
		(r'/p/(\d+)',postviwercontroller.PostViewHandler)
		#(r'/(.*)',basiscontroller.BaseHandler)
		]
