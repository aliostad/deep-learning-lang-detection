
from . import models

SESSION_CART = 'example.cart'

def shopping_cart(request):
    cart = request.session.get(SESSION_CART, None)
    should_save = False
    if cart is None:
        cart = models.Cart()
        request.session[SESSION_CART] = cart
        request.session.save()
        should_save = True
    owner = request.user if (not request.user.is_anonymous()) else None
    if cart.owner != owner:
        cart.owner = owner
        should_save = True
    if should_save:
        cart.save()
    return cart
