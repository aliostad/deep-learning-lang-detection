package notifications

import (
	"io"
	"os"

	"github.com/tchap/steemwatch/notifications/events"
	"github.com/tchap/steemwatch/notifications/notifiers/slack"
	"github.com/tchap/steemwatch/notifications/notifiers/steemitchat"
	"github.com/tchap/steemwatch/notifications/notifiers/telegram"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"gopkg.in/mgo.v2/bson"
)

var availableNotifiers = map[string]Notifier{
	"slack": slack.NewNotifier(),
}

// XXX: Ugly. Would be better to pass the values directly somehow.
func initNotifiers() {
	mustGetenv := func(key string) string {
		// steemit.chat
		v := os.Getenv(key)
		if v == "" {
			panic(key + " is not set")
		}
		return v
	}

	userID := mustGetenv("STEEMWATCH_STEEMIT_CHAT_USER_ID")
	authToken := mustGetenv("STEEMWATCH_STEEMIT_CHAT_AUTH_TOKEN")

	availableNotifiers["steemit-chat"] = steemitchat.NewNotifier(userID, authToken)

	// Telegram
	botToken := mustGetenv("STEEMWATCH_TELEGRAM_BOT_TOKEN")
	bot, err := tgbotapi.NewBotAPI(botToken)
	if err != nil {
		panic(err)
	}

	availableNotifiers["telegram"] = telegram.NewNotifier(bot)
}

type Notifier interface {
	DispatchAccountUpdatedEvent(userId string, userSettings bson.Raw, event *events.AccountUpdated) error
	DispatchAccountWitnessVotedEvent(userId string, userSettings bson.Raw, event *events.AccountWitnessVoted) error
	DispatchTransferMadeEvent(userId string, userSettings bson.Raw, event *events.TransferMade) error
	DispatchUserMentionedEvent(userId string, userSettings bson.Raw, event *events.UserMentioned) error
	DispatchUserFollowStatusChangedEvent(userId string, userSettings bson.Raw, event *events.UserFollowStatusChanged) error
	DispatchStoryPublishedEvent(userId string, userSettings bson.Raw, event *events.StoryPublished) error
	DispatchStoryVotedEvent(userId string, userSettings bson.Raw, event *events.StoryVoted) error
	DispatchCommentPublishedEvent(userId string, userSettings bson.Raw, event *events.CommentPublished) error
	DispatchCommentVotedEvent(userId string, userSettings bson.Raw, event *events.CommentVoted) error

	io.Closer
}
