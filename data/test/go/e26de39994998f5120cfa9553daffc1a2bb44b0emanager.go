package dao

import "github.com/jinzhu/gorm"
import _ "github.com/jinzhu/gorm/dialects/mysql"

type Manager struct {
	*gorm.DB // alias
}

func (m *Manager) Event(locks ...bool) *event {
	return &event{m.DB}
}
func (m *Manager) EventDate() *eventDate {
	return &eventDate{m.DB}
}
func (m *Manager) EventParticipant() *eventParticipant {
	return &eventParticipant{m.DB}
}
func (m *Manager) ParticipantUser() *participantUser {
	return &participantUser{m.DB}
}
func (m *Manager) User() *user {
	return &user{m.DB}
}

func GetManager(tx ...*gorm.DB) *Manager {
	if len(tx) > 0 {
		return &Manager{tx[0]}
	}

	return &Manager{Conn}
}
