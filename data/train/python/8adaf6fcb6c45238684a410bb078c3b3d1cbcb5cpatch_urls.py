
from rest_framework.reverse import reverse


def PUBLIC_APIS(r, f):
    return [
        ('login', reverse('api:api-login', request=r, format=f)),
        ('basket', reverse('api:api-basket', request=r, format=f)),
        ('basket-add-product', reverse('api:api-basket-add-product', request=r,
                                       format=f)),
        ('basket-add-voucher', reverse('api:api-basket-add-voucher', request=r,
                                       format=f)),
        ('basket-shipping-methods', reverse('api:api-basket-shipping-methods', request=r,
                                            format=f)),
        ('checkout', reverse('api:api-checkout', request=r, format=f)),
        ('orders', reverse('api:order-list', request=r, format=f)),
        ('products', reverse('api:product-list', request=r, format=f)),
        ('countries', reverse('api:country-list', request=r, format=f)),
    ]


def PROTECTED_APIS(r, f):
    return [
        ('baskets', reverse('api:basket-list', request=r, format=f)),
        ('lines', reverse('api:line-list', request=r, format=f)),
        ('lineattributes', reverse('api:lineattribute-list', request=r, format=f)),
        ('options', reverse('api:option-list', request=r, format=f)),
        ('stockrecords', reverse('api:stockrecord-list', request=r, format=f)),
        ('users', reverse('api:user-list', request=r, format=f)),
        ('partners', reverse('api:partner-list', request=r, format=f)),
    ]


def patch_urls():
    from oscarapi.views import root
    root.PUBLIC_APIS = PUBLIC_APIS
    root.PROTECTED_APIS = PROTECTED_APIS
