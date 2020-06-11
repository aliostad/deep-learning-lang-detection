__author__ = 'gia'

api_version = '1.0'


def add_blueprints(app):
    from controllers.blue_prints.OAuthController import oauth_controller
    app.register_blueprint(oauth_controller)


def add_apis(api):
    from controllers.apis.ProductsController import ProductsController
    api.add_resource(
        ProductsController,
        '/api/v{0}/{1}'.format(
            api_version,
            getattr(ProductsController, '_resource_name')
        )
    )

    from controllers.apis.CategoriesController import CategoriesController
    api.add_resource(
        CategoriesController,
        '/api/v{0}/{1}'.format(
            api_version,
            getattr(CategoriesController, '_resource_name')
        )
    )


