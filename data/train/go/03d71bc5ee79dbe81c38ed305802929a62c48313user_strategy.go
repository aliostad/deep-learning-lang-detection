package services

import "github.com/cloudfoundry-incubator/notifications/cf"

const UserEndorsement = "This message was sent directly to you."

type UserStrategy struct {
	enqueuer enqueuer
}

func NewUserStrategy(enqueuer enqueuer) UserStrategy {
	return UserStrategy{
		enqueuer: enqueuer,
	}
}

func (strategy UserStrategy) Dispatch(dispatch Dispatch) ([]Response, error) {
	options := Options{
		ReplyTo:           dispatch.Message.ReplyTo,
		Subject:           dispatch.Message.Subject,
		To:                dispatch.Message.To,
		Endorsement:       UserEndorsement,
		KindID:            dispatch.Kind.ID,
		KindDescription:   dispatch.Kind.Description,
		SourceDescription: dispatch.Client.Description,
		Text:              dispatch.Message.Text,
		TemplateID:        dispatch.TemplateID,
		HTML: HTML{
			BodyContent:    dispatch.Message.HTML.BodyContent,
			BodyAttributes: dispatch.Message.HTML.BodyAttributes,
			Head:           dispatch.Message.HTML.Head,
			Doctype:        dispatch.Message.HTML.Doctype,
		},
	}

	users := []User{{GUID: dispatch.GUID}}

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
