# django imports
import django.dispatch

# Catalog
cart_changed = django.dispatch.Signal()
category_changed = django.dispatch.Signal()
product_changed = django.dispatch.Signal()
lfs_sorting_changed = django.dispatch.Signal()

# Marketing
topseller_changed = django.dispatch.Signal()

# Order
order_submitted = django.dispatch.Signal()

# Property
property_type_changed = django.dispatch.Signal()

# TODO: Replace this with "m2m_changed" when available, or think about to use
# an explicit relation ship class
product_removed_property_group = django.dispatch.Signal()

# User
customer_added = django.dispatch.Signal()
