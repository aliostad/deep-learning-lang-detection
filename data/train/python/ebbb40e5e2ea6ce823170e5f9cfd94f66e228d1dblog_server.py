from sys import path
path.append('..')
from wires import *

import controllers.posts_controller as posts_controller
import controllers.comments_controller as comments_controller

import controllers.sessions_controller as sessions_controller
import controllers.users_controller as users_controller

from models.post import Post
from models.user import User

import re

RequestHandler.get[re.compile("^$")] = posts_controller.index
RequestHandler.get[re.compile("^/$")] = posts_controller.index

RequestHandler.get[re.compile("^/posts$")] = posts_controller.index
RequestHandler.get[re.compile("^/posts/(?P<id>\d+)$")] = posts_controller.show
RequestHandler.get[re.compile("^/posts/new$")] = posts_controller.new
RequestHandler.post[re.compile("^/posts$")] = posts_controller.create

RequestHandler.post[re.compile("^/comments$")] = comments_controller.create

RequestHandler.get[re.compile("^/users/(?P<id>\d+)$")] = users_controller.show

RequestHandler.get[re.compile("^/signup$")] = users_controller.new
RequestHandler.post[re.compile("^/signup$")] = users_controller.create

RequestHandler.get[re.compile("^/login$")] = sessions_controller.new
RequestHandler.post[re.compile("^/login$")] = sessions_controller.login
RequestHandler.get[re.compile("^/logout$")] = sessions_controller.logout

if __name__ == '__main__':
    run_server('', 8080, RequestHandler)
