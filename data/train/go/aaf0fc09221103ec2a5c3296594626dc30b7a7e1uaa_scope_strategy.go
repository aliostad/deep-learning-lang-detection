package services

import "github.com/cloudfoundry-incubator/notifications/cf"

const ScopeEndorsement = "You received this message because you have the {{.Scope}} scope."

type scopeUserIDFinder interface {
	UserIDsBelongingToScope(token, scope string) (userIDs []string, err error)
}

type UAAScopeStrategy struct {
	findsUserIDs  scopeUserIDFinder
	tokenLoader   loadsTokens
	enqueuer      enqueuer
	defaultScopes []string
}

func NewUAAScopeStrategy(tokenLoader loadsTokens, findsUserIDs scopeUserIDFinder, enqueuer enqueuer, defaultScopes []string) UAAScopeStrategy {
	return UAAScopeStrategy{
		findsUserIDs:  findsUserIDs,
		tokenLoader:   tokenLoader,
		enqueuer:      enqueuer,
		defaultScopes: defaultScopes,
	}
}

func (strategy UAAScopeStrategy) Dispatch(dispatch Dispatch) ([]Response, error) {
	responses := []Response{}
	options := Options{
		ReplyTo:           dispatch.Message.ReplyTo,
		Subject:           dispatch.Message.Subject,
		To:                dispatch.Message.To,
		Endorsement:       ScopeEndorsement,
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

	if strategy.scopeIsDefault(dispatch.GUID) {
		return responses, DefaultScopeError{}
	}

	token, err := strategy.tokenLoader.Load(dispatch.UAAHost)
	if err != nil {
		return responses, err
	}

	userGUIDs, err := strategy.findsUserIDs.UserIDsBelongingToScope(token, dispatch.GUID)
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
		cf.CloudControllerOrganization{},
		dispatch.Client.ID,
		dispatch.UAAHost,
		dispatch.GUID,
		dispatch.VCAPRequest.ID,
		dispatch.VCAPRequest.ReceiptTime)
}

func (strategy UAAScopeStrategy) scopeIsDefault(scope string) bool {
	for _, singleScope := range strategy.defaultScopes {
		if scope == singleScope {
			return true
		}
	}
	return false
}
