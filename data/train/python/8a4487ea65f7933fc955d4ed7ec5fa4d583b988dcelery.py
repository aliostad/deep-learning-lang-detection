#!/usr/bin/python
"""Primary celery process."""
from __future__ import absolute_import
from celery import Celery
from cart.cart_env_globals import BROKER_URL, BACKEND_URL
CART_APP = Celery('cart',
                  broker=BROKER_URL,
                  backend=BACKEND_URL,
                  include=['cart.tasks'])

# Optional configuration, see the application user guide.
CART_APP.conf.update(
    CELERY_TASK_RESULT_EXPIRES=3600,
)

if __name__ == '__main__':
    # doesnt need coverage since implicitly covered by end to end testing
    CART_APP.start()  # pragma: no cover
