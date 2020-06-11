#!flask/bin/python
from auth import hash_password
from beer_api import BeerListApi, BeerApi
from beer_glass_api import BeerGlassListApi, BeerGlassApi
from beer_review_api import BeerReviewListApi, BeerReviewApi, BeerReviewBeerApi, BeerReviewUserApi
from favorites_api import FavoritesUserApi, FavoritesListApi, FavoritesApi, FavoritesBeerApi
from user_api import UserApi, UserListApi, User
from flask import Flask
from flask.ext.restful import Api


app = Flask(__name__)
api = Api(app)

api.add_resource(UserListApi, '/api/v1.0/users', endpoint='users')
api.add_resource(UserApi, '/api/v1.0/users/<int:id>', endpoint='user')
api.add_resource(BeerReviewUserApi, '/api/v1.0/users/<int:id>/reviews', endpoint='user_reviews')
api.add_resource(BeerGlassListApi, '/api/v1.0/beer_glasses', endpoint='beer_glasses')
api.add_resource(BeerGlassApi, '/api/v1.0/beer_glasses/<int:id>', endpoint='beer_glass')
api.add_resource(BeerListApi, '/api/v1.0/beers', endpoint='beers')
api.add_resource(BeerApi, '/api/v1.0/beers/<int:id>', endpoint='beer')
api.add_resource(BeerReviewBeerApi, '/api/v1.0/beers/<int:id>/reviews', endpoint='beer_reviews')
api.add_resource(BeerReviewListApi, '/api/v1.0/beer_reviews', endpoint='reviews')
api.add_resource(BeerReviewApi, '/api/v1.0/beer_reviews/<int:id>', endpoint='review')
api.add_resource(FavoritesUserApi, '/api/v1.0/users/<int:id>/favorites', endpoint='user_favorites')
api.add_resource(FavoritesBeerApi, '/api/v1.0/beers/<int:id>/favorites', endpoint='beer_favorites')
api.add_resource(FavoritesListApi, '/api/v1.0/favorites', endpoint='favorites')
api.add_resource(FavoritesApi, '/api/v1.0/favorites/<int:id>', endpoint='favorite')

# Create initial user if the user does not exist
u = User.all().get()
if u is None:
    u = User(user_name='admin',
             first_name='Admin',
             last_name='Admin',
             password=hash_password('beer_app1'))
    u.put()


if __name__ == '__main__':
    app.run(debug = True)
