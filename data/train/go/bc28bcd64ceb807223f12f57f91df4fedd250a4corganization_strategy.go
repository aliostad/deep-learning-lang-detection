package services

import "github.com/cloudfoundry-incubator/notifications/cf"

const (
	OrganizationEndorsement     = `You received this message because you belong to the "{{.Organization}}" organization.`
	OrganizationRoleEndorsement = `You received this message because you are an {{.OrganizationRole}} in the "{{.Organization}}" organization.`
)

type orgUserIDFinder interface {
	UserIDsBelongingToOrganization(orgGUID, role, token string) (userIDs []string, err error)
}

type loadsOrganizations interface {
	Load(orgGUID, token string) (cf.CloudControllerOrganization, error)
}

type OrganizationStrategy struct {
	tokenLoader        loadsTokens
	organizationLoader loadsOrganizations
	findsUserIDs       orgUserIDFinder
	enqueuer           enqueuer
}

func NewOrganizationStrategy(tokenLoader loadsTokens, organizationLoader loadsOrganizations, findsUserIDs orgUserIDFinder, queue enqueuer) OrganizationStrategy {
	return OrganizationStrategy{
		tokenLoader:        tokenLoader,
		organizationLoader: organizationLoader,
		findsUserIDs:       findsUserIDs,
		enqueuer:           queue,
	}
}

func (strategy OrganizationStrategy) Dispatch(dispatch Dispatch) ([]Response, error) {
	responses := []Response{}
	options := Options{
		To:                dispatch.Message.To,
		ReplyTo:           dispatch.Message.ReplyTo,
		Subject:           dispatch.Message.Subject,
		KindID:            dispatch.Kind.ID,
		KindDescription:   dispatch.Kind.Description,
		SourceDescription: dispatch.Client.Description,
		Endorsement:       OrganizationEndorsement,
		Text:              dispatch.Message.Text,
		TemplateID:        dispatch.TemplateID,
		Role:              dispatch.Role,
		HTML: HTML{
			BodyContent:    dispatch.Message.HTML.BodyContent,
			BodyAttributes: dispatch.Message.HTML.BodyAttributes,
			Head:           dispatch.Message.HTML.Head,
			Doctype:        dispatch.Message.HTML.Doctype,
		},
	}

	if dispatch.Role != "" {
		options.Endorsement = OrganizationRoleEndorsement
	}

	token, err := strategy.tokenLoader.Load(dispatch.UAAHost)
	if err != nil {
		return responses, err
	}

	organization, err := strategy.organizationLoader.Load(dispatch.GUID, token)
	if err != nil {
		return responses, err
	}

	userGUIDs, err := strategy.findsUserIDs.UserIDsBelongingToOrganization(dispatch.GUID, options.Role, token)
	if err != nil {
		return responses, err
	}

	var users []User
	for _, guid := range userGUIDs {
		users = append(users, User{GUID: guid})
	}

	return strategy.enqueuer.Enqueue(
		dispatch.Connection,
		users,
		options,
		cf.CloudControllerSpace{},
		organization,
		dispatch.Client.ID,
		dispatch.UAAHost,
		"",
		dispatch.VCAPRequest.ID,
		dispatch.VCAPRequest.ReceiptTime)
}
