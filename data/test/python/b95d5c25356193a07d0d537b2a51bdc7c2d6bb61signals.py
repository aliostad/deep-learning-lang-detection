# -*- coding: utf-8 -*-

from __future__ import unicode_literals

from django import dispatch


checkout_preferences_created = dispatch.Signal(providing_args=["checkout_preferences",
                                                               "user_checkout_identifier",
                                                               "request"])

pre_mp_create_preference = dispatch.Signal(providing_args=["payment",
                                                           "user_checkout_identifier",
                                                           "request"])

post_mp_create_preference = dispatch.Signal(providing_args=["payment",
                                                            "create_preference_result",
                                                            "user_checkout_identifier",
                                                            "request"])
