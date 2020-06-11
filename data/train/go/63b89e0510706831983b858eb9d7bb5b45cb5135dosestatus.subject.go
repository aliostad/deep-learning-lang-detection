package main

import (
	"main/dispatch"
	"fmt"
	"reflect"
)

type (
	// DoseStatusesSubject represents a subscribable subject pertaining to a dose status
	DoseStatusesSubject struct {
		Title    string
		messages chan dispatch.SubjectMessage
	}

	// doseStatusesSubscriptionParams contains the subscription parameters to a DoseStatusesSubject
	doseStatusesSubscriptionParams struct {
		UserID int
		Date   string
	}

	// DoseStatusesUpdatedPayload contains the payload for an "updated" message from a DoseStatusesSubject
	DoseStatusesUpdatedPayload struct {
		UserID          int          `json:"-"`
		Date            string       `json:"-"`
		UpdatedStatuses []DoseStatus `json:"updatedStatuses"`
	}
)

// NewDoseStatusesSubject creates a new DoseStatusesSubject
func NewDoseStatusesSubject(dispatcher *dispatch.Dispatcher) *DoseStatusesSubject {
	subject := &DoseStatusesSubject{
		Title:    "dosestatuses",
		messages: make(chan dispatch.SubjectMessage, 10),
	}

	dispatcher.RegisterSubject(subject)

	return subject
}

func (dssp *doseStatusesSubscriptionParams) IsEqualTo(params dispatch.SubscriptionParams) bool {
	if dssp2, ok := params.(*doseStatusesSubscriptionParams); ok {
		return dssp2.UserID == dssp.UserID && dssp2.Date == dssp.Date
	}

	return false
}

func (dss *DoseStatusesSubject) GetTitle() string {
	return dss.Title
}

func (dss *DoseStatusesSubject) CreateSubscriptionParams(params map[string]interface{}) (dispatch.SubscriptionParams, error) {
	uID, ok := params["userId"]
	if !ok {
		return nil, dispatch.BadRequestErrorMessage("Missing field 'userId' in subscription parameters for subject 'dosestatuses'")
	}

	userID, ok := uID.(float64)
	if !ok {
		return nil, dispatch.BadRequestErrorMessage(fmt.Sprintf("Expected field 'userId' to be of type number, got %s", reflect.TypeOf(uID).Name()))
	}

	d, ok := params["date"]
	if !ok {
		return nil, dispatch.BadRequestErrorMessage("Missing field 'date' in subscription parameters for subject 'dosestatuses'")
	}

	date, ok := d.(string)
	if !ok {
		return nil, dispatch.BadRequestErrorMessage(fmt.Sprintf("Expected field 'date' to be of type string, got %s", reflect.TypeOf(d).Name()))
	}

	return &doseStatusesSubscriptionParams{
		UserID: int(userID),
		Date: date,
	}, nil
}

func (dss *DoseStatusesSubject) MessageShouldBeSentToSubscription(message dispatch.SubjectMessage, sp dispatch.SubscriptionParams) bool {
	subscriptionParams, ok := sp.(*doseStatusesSubscriptionParams)
	if !ok {
		return false
	}

	payload, ok := message.Payload.(DoseStatusesUpdatedPayload)
	if !ok {
		return false
	}

	return payload.UserID == subscriptionParams.UserID && payload.Date == subscriptionParams.Date
}

func (dss *DoseStatusesSubject) GetMessageChan() <-chan dispatch.SubjectMessage {
	return dss.messages
}

// DoseStatusesUpdated notifies subscribers of the subject that the dose statuses for a given user ID and date have been updated
func (dss *DoseStatusesSubject) DoseStatusesUpdated(userID int, date string, updatedDoseStatuses []DoseStatus) {
	dss.messages <- dispatch.SubjectMessage {
		Action: dispatch.CollectionEntityUpdatedAction,
		Payload: DoseStatusesUpdatedPayload{
			UserID: userID,
			Date: date,
			UpdatedStatuses: updatedDoseStatuses,
		},
	}
}