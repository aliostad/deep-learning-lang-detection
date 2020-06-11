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

package simple

import (
	. "launchpad.net/gocheck"
	"launchpad.net/ubuntu-push/logger"
	"launchpad.net/ubuntu-push/server/broker"
	"launchpad.net/ubuntu-push/server/broker/testsuite"
	"launchpad.net/ubuntu-push/server/store"
)

// run the common broker test suite against SimpleBroker

// aliasing through embedding to get saner report names by gocheck
type commonBrokerSuite struct {
	testsuite.CommonBrokerSuite
}

var _ = Suite(&commonBrokerSuite{testsuite.CommonBrokerSuite{
	MakeBroker: func(sto store.PendingStore, cfg broker.BrokerConfig, log logger.Logger) testsuite.FullBroker {
		return NewSimpleBroker(sto, cfg, log)
	},
	RevealSession: func(b broker.Broker, deviceId string) broker.BrokerSession {
		return b.(*SimpleBroker).registry[deviceId]
	},
	RevealBroadcastExchange: func(exchg broker.Exchange) *broker.BroadcastExchange {
		return exchg.(*broker.BroadcastExchange)
	},
}})
