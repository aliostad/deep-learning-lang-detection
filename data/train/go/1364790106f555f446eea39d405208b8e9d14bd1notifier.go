package telegram

import (
	"github.com/tchap/steemwatch/errs"
	"github.com/tchap/steemwatch/notifications/events"
	"github.com/tchap/steemwatch/server/routes/api/notifiers/telegram"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"github.com/pkg/errors"
	"gopkg.in/mgo.v2/bson"
)

const DefaultMaxConcurrentRequests = 1000

//
// Notifier
//

type Notifier struct {
	bot                   *tgbotapi.BotAPI
	maxConcurrentRequests uint
	requestSemaphore      chan struct{}
	termCh                chan struct{}
}

func NewNotifier(bot *tgbotapi.BotAPI, opts ...NotifierOption) *Notifier {
	notifier := &Notifier{
		bot: bot,
		maxConcurrentRequests: DefaultMaxConcurrentRequests,
		termCh:                make(chan struct{}),
	}

	for _, opt := range opts {
		opt(notifier)
	}

	notifier.requestSemaphore = make(chan struct{}, notifier.maxConcurrentRequests)

	return notifier
}

type NotifierOption func(*Notifier)

func SetMaxConcurrentRequests(maxConcurrentRequests uint) NotifierOption {
	return func(notifier *Notifier) {
		notifier.maxConcurrentRequests = maxConcurrentRequests
	}
}

func (notifier *Notifier) DispatchAccountUpdatedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.AccountUpdated,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderAccountUpdatedEvent(event)
	})
}

func (notifier *Notifier) DispatchAccountWitnessVotedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.AccountWitnessVoted,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderAccountWitnessVotedEvent(event)
	})
}

func (notifier *Notifier) DispatchTransferMadeEvent(
	userId string,
	userSettings bson.Raw,
	event *events.TransferMade,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderTransferMadeEvent(event)
	})
}

func (notifier *Notifier) DispatchUserMentionedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.UserMentioned,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderUserMentionedEvent(event)
	})
}

func (notifier *Notifier) DispatchUserFollowStatusChangedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.UserFollowStatusChanged,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderUserFollowStatusChangedEvent(event)
	})
}

func (notifier *Notifier) DispatchStoryPublishedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.StoryPublished,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderStoryPublishedEvent(event)
	})
}

func (notifier *Notifier) DispatchStoryVotedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.StoryVoted,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderStoryVotedEvent(event)
	})
}

func (notifier *Notifier) DispatchCommentPublishedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.CommentPublished,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderCommentPublishedEvent(event)
	})
}

func (notifier *Notifier) DispatchCommentVotedEvent(
	userId string,
	userSettings bson.Raw,
	event *events.CommentVoted,
) error {
	return notifier.dispatch(userId, userSettings, func() string {
		return renderCommentVotedEvent(event)
	})
}

func (notifier *Notifier) dispatch(
	userId string,
	userSettings bson.Raw,
	render func() string,
) error {
	var settings telegram.Settings
	if err := userSettings.Unmarshal(&settings); err != nil {
		return errors.Wrap(err, "failed to unmarshal user settings")
	}

	return notifier.send(&settings, render())
}

func (notifier *Notifier) send(settings *telegram.Settings, text string) error {
	// Acquire a request slot.
	select {
	case notifier.requestSemaphore <- struct{}{}:
		defer func() {
			<-notifier.requestSemaphore
		}()
	case <-notifier.termCh:
		return errs.ErrClosing
	}

	// Send the message.
	msg := tgbotapi.NewMessage(settings.ChatID, text)
	msg.ParseMode = "Markdown"
	_, err := notifier.bot.Send(msg)
	return errors.Wrap(err, "failed to send message to Telegram")
}

func (notifier *Notifier) Close() error {
	select {
	case <-notifier.termCh:
		return errs.ErrClosing
	default:
		close(notifier.termCh)
		return nil
	}
}
