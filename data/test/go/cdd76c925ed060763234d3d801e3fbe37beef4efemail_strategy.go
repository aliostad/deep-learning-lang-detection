package services

import (
	"time"

	"github.com/cloudfoundry-incubator/notifications/cf"
)

const EmailEndorsement = "This message was sent directly to your email address."

type EmailStrategy struct {
	enqueuer enqueuer
}

type enqueuer interface {
	Enqueue(
		conn ConnectionInterface,
		users []User,
		opts Options,
		space cf.CloudControllerSpace,
		org cf.CloudControllerOrganization,
		clientID string,
		uaaHost string,
		scope string,
		vcapRequestID string,
		reqReceived time.Time) ([]Response, error)
}

func NewEmailStrategy(enqueuer enqueuer) EmailStrategy {
	return EmailStrategy{
		enqueuer: enqueuer,
	}
}

func (strategy EmailStrategy) Dispatch(dispatch Dispatch) ([]Response, error) {
	options := Options{
		To:                dispatch.Message.To,
		ReplyTo:           dispatch.Message.ReplyTo,
		Subject:           dispatch.Message.Subject,
		KindID:            dispatch.Kind.ID,
		KindDescription:   dispatch.Kind.Description,
		SourceDescription: dispatch.Client.Description,
		Endorsement:       EmailEndorsement,
		Text:              dispatch.Message.Text,
		TemplateID:        dispatch.TemplateID,
		HTML: HTML{
			BodyContent:    dispatch.Message.HTML.BodyContent,
			BodyAttributes: dispatch.Message.HTML.BodyAttributes,
			Head:           dispatch.Message.HTML.Head,
			Doctype:        dispatch.Message.HTML.Doctype,
		},
	}

	users := []User{{Email: dispatch.Message.To}}

	return strategy.enqueuer.Enqueue(
		dispatch.Connection,
		users,
		options,
		cf.CloudControllerSpace{},
		cf.CloudControllerOrganization{},
		dispatch.Client.ID,
		dispatch.UAAHost,
		"",
		dispatch.VCAPRequest.ID,
		dispatch.VCAPRequest.ReceiptTime)
}
