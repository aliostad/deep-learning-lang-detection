#Classes
import Chatter
import ChatRoom
import ChatArchive
import message

#Utils
from constants import *


def initialize(context):
    """ """
    #register classes
    context.registerClass(Chatter.Chatter, 
                          permission=CHATTER_ADD_PERMISSION, 
                          constructors=(Chatter.manage_addChatter_html, 
                                        Chatter.manage_addChatter), 
                         )

#    context.registerClass(ChatRoom.ChatRoom, 
#                          permission=CHATTER_ADD_PERMISSION, 
#                          constructors=(ChatRoom.manage_addChatRoom_html, 
#                                        ChatRoom.manage_addChatRoom), 
#                         )
#
#    context.registerClass(ChatArchive.ChatArchive, 
#                          permission=CHATTER_ADD_PERMISSION, 
#                          constructors=(ChatArchive.manage_addChatArchive_html, 
#                                        ChatArchive.manage_addChatArchive), 
#                         )