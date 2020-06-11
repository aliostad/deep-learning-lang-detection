
def set_model_repository():
    '''set ModelRepository as default Shipping Repository'''
    from leonardo_store.shipping.repository import ModelRepository
    import oscar.apps.shipping.repository
    from oscar.apps.checkout import views
    from oscar.apps.checkout import session
    from oscar.apps.basket import views as basket_views
    session.Repository = ModelRepository
    oscar.apps.shipping.repository.Repository = ModelRepository
    views.Repository = ModelRepository
    basket_views.Repository = ModelRepository
