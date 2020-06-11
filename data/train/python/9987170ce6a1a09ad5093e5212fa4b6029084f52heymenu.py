import webapp2
from webapp2 import Route

from controllers import pages
from controllers import image
from controllers import api
from controllers.api import Category
from controllers.api import Dish 
from controllers.api import CheckRestaurantUid

application = webapp2.WSGIApplication([
  ('/', pages.Index),
  ('/api/dish', api.Dish),
  (Route(r'/api/dish/<dish_key>', api.Dish)),
  ('/api/restaurant', api.Restaurant),
  (Route(r'/api/restaurant/<restaurant_uid>', api.Restaurant)),
  ('/api/category', api.Category),
  ('/api/check_restaurant_uid', api.CheckRestaurantUid),
  ('/p/new-restaurant', pages.NewRestaurant),
  ('/p/signin', pages.SignIn),
  (Route(r'/image/<image_id>', image.ImageHandler)),
  (Route(r'/<restaurant_uid>', pages.Restaurant, name = 'restaurant'))
  ], debug=True)
