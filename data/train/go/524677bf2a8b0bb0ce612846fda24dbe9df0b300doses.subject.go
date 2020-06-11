package main

import (
	"fmt"
	"main/dispatch"
	"reflect"
)

type (
	// DosesSubject represents a subscribable subject pertaining to the doses collection
	DosesSubject struct {
		Title    string
		messages chan dispatch.SubjectMessage
	}

	// dosesSubjectSubscriptionParams contains the subscription parameters to a doses subject
	dosesSubjectSubscriptionParams struct {
		UserID int
	}

	// DosesItemAddedPayload contains the payload for an "added" message
	DosesItemAddedPayload struct {
		ID          int         `json:"id"`
		UserID      int         `json:"-"`
		AddedEntity DoseSummary `json:"addedEntity"`
	}

	// DosesItemUpdatedPayload contains the payload for an "updated" message
	DosesItemUpdatedPayload struct {
		ID            int         `json:"id"`
		UserID        int         `json:"-"`
		UpdatedEntity DoseSummary `json:"updatedEntity"`
	}

	// DosesItemDeletedPayload contains the payload for a "deleted" message
	DosesItemDeletedPayload struct {
		UserID int `json:"-"`
		ID     int `json:"id"`
	}
)

// NewDosesSubject creates a new DosesSubject
func NewDosesSubject(dispatcher *dispatch.Dispatcher) *DosesSubject {
	subject := &DosesSubject{
		Title:    "doses",
		messages: make(chan dispatch.SubjectMessage, 10),
	}

	dispatcher.RegisterSubject(subject)

	return subject
}

func (dssp *dosesSubjectSubscriptionParams) IsEqualTo(params dispatch.SubscriptionParams) bool {
	if dssp2, ok := params.(*dosesSubjectSubscriptionParams); ok {
		return dssp.UserID == dssp2.UserID
	}

	return false
}

func (ds *DosesSubject) GetTitle() string {
	return ds.Title
}

func (ds *DosesSubject) CreateSubscriptionParams(params map[string]interface{}) (dispatch.SubscriptionParams, error) {
	uID, ok := params["userId"]
	if !ok {
		return nil, dispatch.BadRequestErrorMessage("Missing field 'userId' in subscription parameters for subject 'doses'")
	}

	userID, ok := uID.(float64)
	if !ok {
		return nil, dispatch.BadRequestErrorMessage(fmt.Sprintf("Expected field 'userId' to be of type number, got %s", reflect.TypeOf(uID).Name()))
	}

	return &dosesSubjectSubscriptionParams{
		UserID: int(userID),
	}, nil
}

func (ds *DosesSubject) MessageShouldBeSentToSubscription(message dispatch.SubjectMessage, sp dispatch.SubscriptionParams) bool {
	subscriptionParams, ok := sp.(*dosesSubjectSubscriptionParams)
	if !ok {
		return false
	}

	switch message.Payload.(type) {
	case DosesItemAddedPayload:
		return message.Payload.(DosesItemAddedPayload).UserID == subscriptionParams.UserID
	case DosesItemUpdatedPayload:
		return message.Payload.(DosesItemUpdatedPayload).UserID == subscriptionParams.UserID
	case DosesItemDeletedPayload:
		return message.Payload.(DosesItemDeletedPayload).UserID == subscriptionParams.UserID
	default:
		return false
	}
}

func (ds *DosesSubject) GetMessageChan() <-chan dispatch.SubjectMessage {
	return ds.messages
}

// DoseAdded notifies subscribers of the subject that a dose has been added
func (ds *DosesSubject) DoseAdded(userID int, addedDose DoseSummary) {
	ds.messages <- dispatch.SubjectMessage {
		Action: dispatch.CollectionEntityAddedAction,
		Payload: DosesItemAddedPayload{
			ID: addedDose.ID,
			UserID: userID,
			AddedEntity: addedDose,
		},
	}
}

// DoseUpdated notifies subscribers of the subject that a dose has been updated
func (ds *DosesSubject) DoseUpdated(userID int, updatedDose DoseSummary) {
	ds.messages <- dispatch.SubjectMessage {
		Action: dispatch.CollectionEntityUpdatedAction,
		Payload: DosesItemUpdatedPayload{
			ID: updatedDose.ID,
			UserID: userID,
			UpdatedEntity: updatedDose,
		},
	}
}

// DoseDeleted notifies subscribers of the subject that a dose has been deleted
func (ds *DosesSubject) DoseDeleted(userID, doseID int) {
	ds.messages <- dispatch.SubjectMessage {
		Action: dispatch.CollectionEntityDeletedAction,
		Payload: DosesItemDeletedPayload{
			ID: doseID,
			UserID: userID,
		},
	}
}