// Copyright © 2017 The Things Network
// Use of this source code is governed by the MIT license that can be found in the LICENSE file.

package handler

import (
	"fmt"

	"github.com/TheThingsNetwork/ttn/amqp"
	pb_broker "github.com/TheThingsNetwork/ttn/api/broker"
	pb "github.com/TheThingsNetwork/ttn/api/handler"
	"github.com/TheThingsNetwork/ttn/core/component"
	"github.com/TheThingsNetwork/ttn/core/handler/application"
	"github.com/TheThingsNetwork/ttn/core/handler/device"
	"github.com/TheThingsNetwork/ttn/core/types"
	"github.com/TheThingsNetwork/ttn/mqtt"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"gopkg.in/redis.v5"
)

// Handler component
type Handler interface {
	component.Interface
	component.ManagementInterface

	WithMQTT(username, password string, brokers ...string) Handler
	WithAMQP(username, password, host, exchange string) Handler

	HandleUplink(uplink *pb_broker.DeduplicatedUplinkMessage) error
	HandleActivationChallenge(challenge *pb_broker.ActivationChallengeRequest) (*pb_broker.ActivationChallengeResponse, error)
	HandleActivation(activation *pb_broker.DeduplicatedDeviceActivationRequest) (*pb.DeviceActivationResponse, error)
	EnqueueDownlink(appDownlink *types.DownlinkMessage) error
}

// NewRedisHandler creates a new Redis-backed Handler
func NewRedisHandler(client *redis.Client, ttnBrokerID string) Handler {
	return &handler{
		devices:      device.NewRedisDeviceStore(client, "handler"),
		applications: application.NewRedisApplicationStore(client, "handler"),
		ttnBrokerID:  ttnBrokerID,
	}
}

type handler struct {
	*component.Component

	devices      device.Store
	applications application.Store

	ttnBrokerID      string
	ttnBrokerConn    *grpc.ClientConn
	ttnBroker        pb_broker.BrokerClient
	ttnBrokerManager pb_broker.BrokerManagerClient

	downlink chan *pb_broker.DownlinkMessage

	mqttClient   mqtt.Client
	mqttUsername string
	mqttPassword string
	mqttBrokers  []string
	mqttEnabled  bool
	mqttUp       chan *types.UplinkMessage
	mqttEvent    chan *types.DeviceEvent

	amqpClient   amqp.Client
	amqpUsername string
	amqpPassword string
	amqpHost     string
	amqpExchange string
	amqpEnabled  bool
	amqpUp       chan *types.UplinkMessage

	status *status
}

var (
	// AMQPDownlinkQueue is the AMQP queue to use for downlink
	AMQPDownlinkQueue = "ttn-handler-downlink"
)

func (h *handler) WithMQTT(username, password string, brokers ...string) Handler {
	h.mqttUsername = username
	h.mqttPassword = password
	h.mqttBrokers = brokers
	h.mqttEnabled = true
	return h
}

func (h *handler) WithAMQP(username, password, host, exchange string) Handler {
	h.amqpUsername = username
	h.amqpPassword = password
	h.amqpHost = host
	h.amqpExchange = exchange
	h.amqpEnabled = true
	return h
}

func (h *handler) Init(c *component.Component) error {
	h.Component = c
	h.InitStatus()
	err := h.Component.UpdateTokenKey()
	if err != nil {
		return err
	}

	err = h.Announce()
	if err != nil {
		return err
	}

	if h.mqttEnabled {
		var brokers []string
		for _, broker := range h.mqttBrokers {
			brokers = append(brokers, fmt.Sprintf("tcp://%s", broker))
		}
		err = h.HandleMQTT(h.mqttUsername, h.mqttPassword, brokers...)
		if err != nil {
			return err
		}
	}

	if h.amqpEnabled {
		err = h.HandleAMQP(h.amqpUsername, h.amqpPassword, h.amqpHost, h.amqpExchange, AMQPDownlinkQueue)
		if err != nil {
			return err
		}
	}

	err = h.associateBroker()
	if err != nil {
		return err
	}

	h.Component.SetStatus(component.StatusHealthy)

	return nil
}

func (h *handler) Shutdown() {
	if h.mqttEnabled {
		h.mqttClient.Disconnect()
	}
	if h.amqpEnabled {
		h.amqpClient.Disconnect()
	}
}

func (h *handler) associateBroker() error {
	broker, err := h.Discover("broker", h.ttnBrokerID)
	if err != nil {
		return err
	}
	conn, err := broker.Dial()
	if err != nil {
		return err
	}
	h.ttnBrokerConn = conn
	h.ttnBroker = pb_broker.NewBrokerClient(conn)
	h.ttnBrokerManager = pb_broker.NewBrokerManagerClient(conn)

	h.downlink = make(chan *pb_broker.DownlinkMessage)

	contextFunc := func() context.Context { return h.GetContext("") }

	upStream := pb_broker.NewMonitoredHandlerSubscribeStream(h.ttnBroker, contextFunc)
	downStream := pb_broker.NewMonitoredHandlerPublishStream(h.ttnBroker, contextFunc)

	go func() {
		for message := range upStream.Channel() {
			go h.HandleUplink(message)
		}
	}()

	go func() {
		for message := range h.downlink {
			if err := downStream.Send(message); err != nil {
				h.Ctx.WithError(err).Warn("Could not send downlink to Broker")
			}
		}
	}()

	return nil
}
