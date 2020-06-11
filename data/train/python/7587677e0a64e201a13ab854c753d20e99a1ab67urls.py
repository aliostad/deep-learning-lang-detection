__author__ = 'ilya'

from API.handlers import user, auth, posts, categories

urls = [
    (r'/api/users', user.UsersHandler),
    (r'/api/current_user', user.CurrentUser),
    (r'/api/users/(.*)/posts', posts.UserPostsHandler),
    (r'/api/users/(.*)/rating', user.UserRating),
    (r'/api/users/(.*)', user.UserHandler),
    (r'/api/categories', categories.CategoriesHandler),
    (r'/api/categories/(.*)', categories.CategoryHandler),
    (r'/api/threads', posts.ThreadsHandler),
    (r'/api/threads/(.*)', posts.ThreadHandler),
    (r'/api/posts', posts.PostsHandler),
    (r'/api/login', auth.Login),
    (r'/api/logout', auth.Logout)
]
