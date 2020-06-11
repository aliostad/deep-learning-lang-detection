# -*- coding: utf-8 -*-

"""Tweet views."""

import logging
logger = logging.getLogger(__name__)

from pyramid.view import view_config

from pyramid_basemodel import save as save_to_db

from ..model import Tweet

@view_config(context=Tweet, name='hide', request_method='POST', xhr=True,
        renderer='json', permission='edit') 
def hide_tweet_view(request, save=None):
    """Hide a Tweet."""
    
    # Test jig.
    if save is None:
        save = save_to_db
    
    request.context.hidden = True
    save(request.context)
    return {'status': 'OK'}

