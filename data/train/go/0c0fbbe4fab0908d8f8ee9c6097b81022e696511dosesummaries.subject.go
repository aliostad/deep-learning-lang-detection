package main

import (
	"fmt"
	"main/dispatch"
	"reflect"
)

type (
	// DosesSubject represents a subscribable subject pertaining to the dose summaries collection
	DoseSummariesSubject struct {
		Title    string
		messages chan dispatch.SubjectMessage
	}

	// doseSummariesSubscriptionParams contains the subscription parameters to a DoseSummariesSubject subject
	doseSummariesSubscriptionParams struct {
		UserID int
	}

	// DoseSummariesUpdatedPayload contains the payload for an "updated" message
	DoseSummariesUpdatedPayload struct {
		UserID           int                  `json:"-"`
		UpdatedSummaries []DoseSummarySummary `json:"updatedSummaries"`
	}
)

// NewDoseSummariesSubject creates a new DoseSummariesSubject
func NewDoseSummariesSubject(dispatcher *dispatch.Dispatcher) *DoseSummariesSubject {
	subject := &DoseSummariesSubject{
		Title:    "dosesummaries",
		messages: make(chan dispatch.SubjectMessage, 10),
	}

	dispatcher.RegisterSubject(subject)

	return subject
}

func (dssp *doseSummariesSubscriptionParams) IsEqualTo(params dispatch.SubscriptionParams) bool {
	if dssp2, ok := params.(*doseSummariesSubscriptionParams); ok {
		return dssp.UserID == dssp2.UserID
	}

	return false
}

func (dss *DoseSummariesSubject) GetTitle() string {
	return dss.Title
}

func (dss *DoseSummariesSubject) CreateSubscriptionParams(params map[string]interface{}) (dispatch.SubscriptionParams, error) {
	uID, ok := params["userId"]
	if !ok {
		return nil, dispatch.BadRequestErrorMessage("Missing field 'userId' in subscription parameters for subject 'dosesummaries'")
	}

	userID, ok := uID.(float64)
	if !ok {
		return nil, dispatch.BadRequestErrorMessage(fmt.Sprintf("Expected field 'userId' to be of type number, got %s", reflect.TypeOf(uID).Name()))
	}

	return &doseSummariesSubscriptionParams{
		UserID: int(userID),
	}, nil
}

func (dss *DoseSummariesSubject) MessageShouldBeSentToSubscription(message dispatch.SubjectMessage, sp dispatch.SubscriptionParams) bool {
	subscriptionParams, ok := sp.(*doseSummariesSubscriptionParams)
	if !ok {
		return false
	}

	payload, ok := message.Payload.(DoseSummariesUpdatedPayload)
	if !ok {
		return false
	}

	return payload.UserID == subscriptionParams.UserID
}

func (dss *DoseSummariesSubject) GetMessageChan() <-chan dispatch.SubjectMessage {
	return dss.messages
}

// DoseSummariesUpdated notifies subscribers of the subject that the dose summaries list has been updated
func (dss *DoseSummariesSubject) DoseSummariesUpdated(userID int, updatedDoseSummaries []DoseSummarySummary) {
	dss.messages <- dispatch.SubjectMessage{
		Action: dispatch.CollectionEntityUpdatedAction,
		Payload: DoseSummariesUpdatedPayload{
			UserID:           userID,
			UpdatedSummaries: updatedDoseSummaries,
		},
	}
}
