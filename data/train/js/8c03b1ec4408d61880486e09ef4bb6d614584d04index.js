"use strict";

/********************************************************************
 * This thing will just bundle the classes in ./lib/message_classes *
 ********************************************************************/

/************************
 * Requires and exports *
 ************************/

module.exports = {
	Message: require("./message"),
	FileMessage: require("./file_message"),
	LocationMessage: require("./location_message"),
	ContactMessage: require("./contact_message"),
	TextMessage: require("./text_message"),
	ForwardedMessage: require("./forwarded_message"),
	ReplyMessage: require("./reply_message"),
	CommandMessage: require("./command_message"),
	AudioMessage: require("./audio_message"),
	DocumentMessage: require("./document_message"),
	PhotoMessage: require("./photo_message"),
	StickerMessage: require("./sticker_message"),
	VideoMessage: require("./video_message"),
	VoiceMessage: require("./voice_message"),
	NewChatParticipantMessage: require("./new_chat_participant_message"),
	LeftChatParticipantMessage: require("./left_chat_participant_message"),
	NewChatTitleMessage: require("./new_chat_title_message"),
	NewChatPhotoMessage: require("./new_chat_photo_message"),
	DeleteChatPhotoMessage: require("./delete_chat_photo_message"),
	GroupChatCreatedMessage: require("./group_chat_created_message"),
	SupergroupChatCreatedMessage: require("./supergroup_chat_created_message"),
	ChannelChatCreatedMessage: require("./channel_chat_created_message"),
	ChatMigratedMessage: require("./chat_migrated_message")
};
