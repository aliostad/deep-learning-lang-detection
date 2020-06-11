package main

import (
	"fmt"
	"main/dispatch"
	"reflect"
)

type (
	// PRNSubject represents a subscribable subject pertaining to the PRN medications collection
	PRNSubject struct {
		Title    string
		messages chan dispatch.SubjectMessage
	}

	// prnSubjectSubscriptionParams contains the subscription parameters to a PRN medications subject
	prnSubjectSubscriptionParams struct {
		UserID int
	}

	// PRNItemAdded contains the payload for an "added" message
	PRNItemAddedPayload struct {
		ID          int                  `json:"id"`
		UserID      int                  `json:"-"`
		AddedEntity PRNMedicationSummary `json:"addedEntity"`
	}

	// PRNItemUpdatedPayload contains the payload for an "updated" message
	PRNItemUpdatedPayload struct {
		ID            int                  `json:"id"`
		UserID        int                  `json:"-"`
		UpdatedEntity PRNMedicationSummary `json:"addedEntity"`
	}

	// PRNItemDeletedPayload contains the payload for a "deleted" message
	PRNItemDeletedPayload struct {
		UserID int `json:"-"`
		ID     int `json:"id"`
	}
)

// NewPRNSubject creates a new PRNSubject and registers it wit the dispatcher
func NewPRNSubject(dispatcher *dispatch.Dispatcher) *PRNSubject {
	subject := &PRNSubject{
		Title:    "prnMedications",
		messages: make(chan dispatch.SubjectMessage, 10),
	}

	dispatcher.RegisterSubject(subject)

	return subject
}

func (prnssp *prnSubjectSubscriptionParams) IsEqualTo(params dispatch.SubscriptionParams) bool {
	if prnssp2, ok := params.(*prnSubjectSubscriptionParams); ok {
		return prnssp2.UserID == prnssp.UserID
	}

	return false
}

func (prns *PRNSubject) GetTitle() string {
	return prns.Title
}

func (prns *PRNSubject) CreateSubscriptionParams(params map[string]interface{}) (dispatch.SubscriptionParams, error) {
	uID, ok := params["userId"]
	if !ok {
		return nil, dispatch.BadRequestErrorMessage("Missing field 'userId' in subscription parameters for subject 'prnMedications'")
	}

	userID, ok := uID.(float64)
	if !ok {
		return nil, dispatch.BadRequestErrorMessage(fmt.Sprintf("Expected field 'userId' to be of type number, got %s", reflect.TypeOf(uID).Name()))
	}

	return &prnSubjectSubscriptionParams{
		UserID: int(userID),
	}, nil
}

func (prns *PRNSubject) MessageShouldBeSentToSubscription(message dispatch.SubjectMessage, sp dispatch.SubscriptionParams) bool {
	subscriptionParams, ok := sp.(*prnSubjectSubscriptionParams)
	if !ok {
		return false
	}

	switch message.Payload.(type) {
	case PRNItemAddedPayload:
		return message.Payload.(PRNItemAddedPayload).UserID == subscriptionParams.UserID
	case PRNItemUpdatedPayload:
		return message.Payload.(PRNItemUpdatedPayload).UserID == subscriptionParams.UserID
	case PRNItemDeletedPayload:
		return message.Payload.(PRNItemDeletedPayload).UserID == subscriptionParams.UserID
	default:
		return false
	}
}

func (prns *PRNSubject) GetMessageChan() <-chan dispatch.SubjectMessage {
	return prns.messages
}

// PRNMedicationAdded notifies subscribers of the subject that a PRN medication has been added
func (prns *PRNSubject) PRNMedicationAdded(userID int, prnMedicationSummary PRNMedicationSummary) {
	prns.messages <- dispatch.SubjectMessage{
		Action: dispatch.CollectionEntityAddedAction,
		Payload: PRNItemAddedPayload{
			ID:          prnMedicationSummary.ID,
			UserID:      userID,
			AddedEntity: prnMedicationSummary,
		},
	}
}

// PRNMedicationUpdated notifies subscribers of the subject that a PRN medication has been updated
func (prns *PRNSubject) PRNMedicationUpdated(userID int, prnMedicationSummary PRNMedicationSummary) {
	prns.messages <- dispatch.SubjectMessage{
		Action: dispatch.CollectionEntityUpdatedAction,
		Payload: PRNItemUpdatedPayload{
			ID:            prnMedicationSummary.ID,
			UserID:        userID,
			UpdatedEntity: prnMedicationSummary,
		},
	}
}

// PRNMedicationDeleted notifies subscribers of the subject that a PRN medication has been deleted
func (prns *PRNSubject) PRNMedicationDeleted(userID, medicationID int) {
	prns.messages <- dispatch.SubjectMessage{
		Action: dispatch.CollectionEntityUpdatedAction,
		Payload: PRNItemUpdatedPayload{
			UserID: userID,
			ID:     medicationID,
		},
	}
}
