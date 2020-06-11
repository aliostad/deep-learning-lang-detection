package server

import (
	"golang.struktur.de/spreedbox/spreedbox-go/bus"
	"golang.struktur.de/spreedbox/spreedbox-notify/notify"
)

type TriggerManager struct {
	ec *bus.EncodedConn
}

func NewTriggerManager(ec *bus.EncodedConn) *TriggerManager {
	return &TriggerManager{
		ec: ec,
	}
}

func (manager *TriggerManager) TriggerCreated(event *notify.NotificationCreateRequest, trigger string) error {
	manager.ec.Publish(notify.NotifySubjectEventCreated(), event)
	manager.Trigger(trigger, event)
	return nil
}

func (manager *TriggerManager) TriggerClosed(event *notify.NotificationClosedEvent, trigger string) error {
	manager.ec.Publish(notify.NotifySubjectEventClosed(), event)
	manager.Trigger(trigger, event)
	return nil
}

func (manager *TriggerManager) TriggerClicked(event *notify.NotificationClickedEvent, trigger string) error {
	manager.ec.Publish(notify.NotifySubjectEventClicked(), event)
	manager.Trigger(trigger, event)
	return nil
}

func (manager *TriggerManager) Trigger(subject string, v interface{}) error {
	if subject == "" {
		return nil
	}
	return manager.ec.Publish(subject, v)
}
