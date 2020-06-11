/*
 Copyright 2013-2014 Canonical Ltd.

 This program is free software: you can redistribute it and/or modify it
 under the terms of the GNU General Public License version 3, as published
 by the Free Software Foundation.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranties of
 MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 PURPOSE.  See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along
 with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// Package testing contains simple test implementations of some broker interfaces.
package testing

import (
	"launchpad.net/ubuntu-push/protocol"
	"launchpad.net/ubuntu-push/server/broker"
	"launchpad.net/ubuntu-push/server/store"
)

// Test implementation of BrokerSession.
type TestBrokerSession struct {
	DeviceId     string
	Model        string
	ImageChannel string
	Exchanges    chan broker.Exchange
	LevelsMap    broker.LevelsMap
	exchgScratch broker.ExchangesScratchArea
	// hooks
	DoGet         func(store.InternalChannelId, bool) (int64, []protocol.Notification, error)
	DoDropByMsgId func(store.InternalChannelId, []protocol.Notification) error
}

func (tbs *TestBrokerSession) DeviceIdentifier() string {
	return tbs.DeviceId
}

func (tbs *TestBrokerSession) DeviceImageModel() string {
	return tbs.Model
}

func (tbs *TestBrokerSession) DeviceImageChannel() string {
	return tbs.ImageChannel
}

func (tbs *TestBrokerSession) SessionChannel() <-chan broker.Exchange {
	return tbs.Exchanges
}

func (tbs *TestBrokerSession) Levels() broker.LevelsMap {
	return tbs.LevelsMap
}

func (tbs *TestBrokerSession) ExchangeScratchArea() *broker.ExchangesScratchArea {
	return &tbs.exchgScratch
}

func (tbs *TestBrokerSession) Get(chanId store.InternalChannelId, cachedOk bool) (int64, []protocol.Notification, error) {
	return tbs.DoGet(chanId, cachedOk)
}

func (tbs *TestBrokerSession) DropByMsgId(chanId store.InternalChannelId, targets []protocol.Notification) error {
	return tbs.DoDropByMsgId(chanId, targets)
}

func (tbs *TestBrokerSession) Feed(exchg broker.Exchange) {
	tbs.Exchanges <- exchg
}

func (tbs *TestBrokerSession) InternalChannelId() store.InternalChannelId {
	return store.UnicastInternalChannelId(tbs.DeviceId, tbs.DeviceId)
}

// Test implementation of BrokerConfig.
type TestBrokerConfig struct {
	ConfigSessionQueueSize uint
	ConfigBrokerQueueSize  uint
}

func (tbc *TestBrokerConfig) SessionQueueSize() uint {
	return tbc.ConfigSessionQueueSize
}

func (tbc *TestBrokerConfig) BrokerQueueSize() uint {
	return tbc.ConfigBrokerQueueSize
}
