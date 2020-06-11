"use strict";

/**
 * GameMessage
 * class for game message objects
 * @constructor
 */
function GameMessage(messageType) {
    this.type = GameMessage.Type;
    this.messageType = messageType;
    this.gameID = "";
    this.from = User.load().getUsername();
    this.toPlayerNumber = "";
    this.text = "";
    this.party = [];
    this.pieces = [];
    this.blocks = [];
	this.previousPlayer;
    this.playerNumber = "";
}

// different game message types
GameMessage.Type = "GameMessage";
GameMessage.NextUserMessage = "NextUserMessage";
GameMessage.PauseRequestMessage = "PauseRequestMessage";
GameMessage.GameChatMessage = "GameChatMessage";
GameMessage.PiecesChangedMessage = "PiecesChangedMessage";
GameMessage.GameHasEndedMessage = "GameHasEndedMessage";
GameMessage.ShortPauseMessage = "ShortPauseMessage";
GameMessage.UnPauseMessage = "UnPauseMessage";
GameMessage.StopGameMessage = "StopGameMessage";
GameMessage.PlayAgainMessage = "PlayAgainMessage";
GameMessage.PlayerForfeitMessage = "PlayerForfeitMessage";