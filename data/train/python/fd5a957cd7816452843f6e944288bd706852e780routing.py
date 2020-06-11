# The contents of this file are subject to the Common Public Attribution
# License Version 1.0. (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
# License Version 1.1, but Sections 14 and 15 have been added to cover use of
# software over a computer network and provide for limited attribution for the
# Original Developer. In addition, Exhibit A has been modified to be consistent
# with Exhibit B.
# 
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
# 
# The Original Code is Reddit.
# 
# The Original Developer is the Initial Developer.  The Initial Developer of the
# Original Code is CondeNet, Inc.
# 
# All portions of the code written by CondeNet are Copyright (c) 2006-2009
# CondeNet, Inc. All Rights Reserved.
################################################################################
"""
Setup your Routes options here
"""
import os
from routes import Mapper
import admin_routes

def make_map(global_conf={}, app_conf={}):
    map = Mapper()
    mc = map.connect

    admin_routes.add(mc)
    
    mc('/login',    controller='front', action='login')
    mc('/logout',   controller='front', action='logout')
    mc('/adminon',  controller='front', action='adminon')
    mc('/adminoff', controller='front', action='adminoff')
    mc('/submit',   controller='front', action='submit')
    mc('/validuser',   controller='front', action='validuser')

    mc('/over18',   controller='post', action='over18')
    
    mc('/search', controller='front', action='search')

    mc('/sup', controller='front', action='sup')
    mc('/traffic', controller='front', action='site_traffic')
    
    mc('/about/:location', controller='front', 
       action='editreddit', location = 'about')
    
    mc('/reddits/create', controller='front', action='newreddit')
    mc('/reddits/search', controller='front', action='search_reddits')
    mc('/reddits/:where', controller='reddits', action='listing',
       where = 'popular',
       requirements=dict(where="popular|new|banned"))

    mc('/reddits/mine/:where', controller='myreddits', action='listing',
       where='subscriber',
       requirements=dict(where='subscriber|contributor|moderator'))
    
    mc('/buttons', controller='buttons', action='button_demo_page')
    #the frame
    mc('/button_content', controller='buttons', action='button_content')
    #/button.js and buttonlite.js - the embeds
    mc('/button', controller='buttons', action='button_embed')
    mc('/buttonlite', controller='buttons', action='button_lite')
    
    mc('/widget', controller='buttons', action='widget_demo_page')
    mc('/bookmarklets', controller='buttons', action='bookmarklets')
    
    mc('/stats', controller='front', action='stats')
    
    mc('/feedback', controller='feedback', action='feedback')
    mc('/ad_inq',   controller='feedback', action='ad_inq')
    

    mc('/admin/i18n', controller='i18n', action='list')
    mc('/admin/i18n/:action', controller='i18n')
    mc('/admin/i18n/:action/:lang', controller='i18n')

    mc('/admin/:action', controller='admin')
    
    mc('/user/:username/about', controller='user', action='about',
       where='overview')
    mc('/user/:username/:where', controller='user', action='listing',
       where='overview')
    
    mc('/prefs/:location', controller='front',
       action='prefs', location='options')
    
    mc('/info/0:article/*rest', controller = 'front', 
       action='oldinfo', dest='comments', type='ancient')
    mc('/info/:article/:dest/:comment', controller='front',
       action='oldinfo', type='old', dest='comments', comment=None)

    mc('/related/:article/:title', controller='front',
       action = 'related', title=None)
    mc('/details/:article/:title', controller='front',
       action = 'details', title=None)
    mc('/traffic/:article/:title', controller='front',
       action = 'traffic', title=None)
    mc('/shirt/:article/:title', controller='front',
       action = 'shirt', title=None)
    mc('/comments/:article/:title/:comment', controller='front', 
       action = 'comments', title=None, comment = None)
    mc('/duplicates/:article/:title', controller = 'front',
       action = 'duplicates', title=None)
    
    mc('/mail/optout', controller='front', action = 'optout')
    mc('/mail/optin',  controller='front', action = 'optin')
    mc('/stylesheet', controller = 'front', action = 'stylesheet')
    mc('/frame', controller='front', action = 'frame')
    mc('/framebuster/:blah', controller='front', action = 'framebuster')
    mc('/framebuster/:what/:blah',
       controller='front', action = 'framebuster')

    mc('/promote/edit_promo/:link', controller='promote', action = 'edit_promo')
    mc('/promote/:action', controller='promote')

    mc('/', controller='upcoming', action='listing')
    
    listing_controllers = "hot|saved|toplinks|new|upcoming|recommended|randomrising|comments"

    mc('/:controller', action='listing',
       requirements=dict(controller=listing_controllers))

    mc('/by_id/:names', controller='byId', action='listing')

    mc('/:sort', controller='browse', sort='top', action = 'listing',
       requirements = dict(sort = 'top|controversial'))
    
    mc('/message/compose', controller='message', action='compose')
    mc('/message/:where', controller='message', action='listing')
    
    mc('/:action', controller='front',
       requirements=dict(action="password|random|framebuster"))
    mc('/:action', controller='embed',
       requirements=dict(action="help|blog"))
    mc('/help/:anything', controller='embed', action='help')
    
    mc('/goto', controller='toolbar', action='goto')
    mc('/tb/:id', controller='toolbar', action='tb')
    mc('/toolbar/:action', controller='toolbar',
       requirements=dict(action="toolbar|inner|login"))
    mc('/toolbar/comments/:id', controller='toolbar', action='comments')

    mc('/s/*rest', controller='toolbar', action='s')
    # additional toolbar-related rules just above the catchall

    mc('/d/:what', controller='api', action='bookmarklet')
    
    mc('/resetpassword/:key', controller='front',
       action='resetpassword')
    mc('/resetpassword', controller='front',
       action='resetpassword')

    mc('/post/:action/:url_user', controller='post',
       requirements=dict(action="login|reg"))
    mc('/post/:action', controller='post',
       requirements=dict(action="options|over18|unlogged_options|optout|optin|login|reg"))
    
    mc('/api/distinguish/:how', controller='api', action="distinguish")
    mc('/api/:action/:url_user', controller='api',
       requirements=dict(action="login|register"))
    mc('/api/gadget/click/:ids', controller = 'api', action='gadget', type='click')
    mc('/api/gadget/:type', controller = 'api', action='gadget')
    mc('/api/:action', controller='api')
    
    mc('/captcha/:iden', controller='captcha', action='captchaimg')

    mc('/mediaembed/:link', controller="mediaembed", action="mediaembed")

    mc('/doquery', controller='query', action='doquery')

    mc('/store', controller='redirect', action='redirect',
       dest='http://store.reddit.com/index.html')
    
    mc('/code', controller='redirect', action='redirect',
       dest='http://code.reddit.com/')
    
    mc('/mobile', controller='redirect', action='redirect',
       dest='http://m.reddit.com/')

    mc('/authorize_embed', controller = 'front', action = 'authorize_embed')
    
    # This route handles displaying the error page and 
    # graphics used in the 404/500
    # error pages. It should likely stay at the top 
    # to ensure that the error page is
    # displayed properly.
    mc('/error/document/:id', controller='error', action="document")

    # these should be near the buttom, because they should only kick
    # in if everything else fails. It's the attempted catch-all
    # reddit.com/http://... and reddit.com/34fr, but these redirect to
    # the less-guessy versions at /s/ and /tb/
    mc('/:linkoid', controller='toolbar', action='linkoid',
       requirements=dict(linkoid='[0-9a-z]{1,6}'))
    mc('/:urloid', controller='toolbar', action='urloid',
       requirements=dict(urloid=r'(\w+\.\w{2,}|https?).*'))

    mc("/*url", controller='front', action='catchall')

    return map

