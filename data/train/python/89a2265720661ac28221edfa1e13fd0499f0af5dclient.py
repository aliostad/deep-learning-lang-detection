'''
Created on Aug 2, 2009

@author: aleksandrcicenin
'''

from .partial import account, block, direct_message, favorite, friendship, help, \
notification, saved_searches, social_graph, status, user

class ClientAPI(account.AccountAPI, block.BlockAPI, direct_message.DirectMessageAPI, 
          favorite.FavoriteAPI, friendship.FriendshipAPI, help.HelpAPI, 
          notification.NotificationAPI, saved_searches.SavedSearchesAPI,
          social_graph.SocialGraphAPI, status.StatusAPI,
          user.UserAPI):
    pass