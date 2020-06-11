"use strict";

/**
 * ChatMessage
 * class for chat message objects
 * @constructor
 */
function ChatMessage(messageType) {

    this.type = ChatMessage.Type;
    this.messageType = messageType;
    this.text = "";
    this.from = User.load().getUsername();
    this.to = "";
    this.readyState = "";
    this.party = [];
    this.id = "";
    this.startPlayer = "";

}

// different message types
                    ChatMessage.Type = "ChatMessage";
             ChatMessage.TextMessage = "ChatText";
          ChatMessage.ConnectMessage = "ConnectMessage";
        ChatMessage.StartGameMessage = "StartGameMessage";
       ChatMessage.DisconnectMessage = "DisconnectMessage";
       ChatMessage.InvitationMessage = "InvitationMessage";
      ChatMessage.AlreadyHereMessage = "AlreadyHereMessage";
    ChatMessage.NewReadyStateMessage = "NewReadyStateMessage";
   ChatMessage.NewPartyMemberMessage = "NewPartyMemberMessage";
ChatMessage.DeclineInvitationMessage = "DeclineInvitationMessage";
ChatMessage.AcceptInvitationMessage = "AcceptInvitationMessage";
